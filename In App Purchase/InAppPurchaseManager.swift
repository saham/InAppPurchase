import StoreKit

protocol InAppPurchaseManagerDelegate: AnyObject {
    func purchaseSucceeded(transaction: Transaction)
    func purchaseFailed(error: Error)
    func restoredSucceeded(transaction: Transaction)
    func restoreFailed(error: Error)
    func transactionListener(transaction:Transaction, error: Error?)
    func fetchFailed(error: Error)
    func fetchSucceeded(products: [Product])
}

@MainActor
class InAppPurchaseManager {
    static let shared = InAppPurchaseManager()
    weak var delegate: InAppPurchaseManagerDelegate?
    var products: [Product] = []
    private init() {}
    
    func getProducts() -> [Product] {
       return self.products.sorted(by: {$0.price < $1.price})
    }
    func fetchProducts() async {
        do {
            let ids = ProductId.allCases.map { $0.rawValue }
            self.products = try await Product.products(for: ids)
            delegate?.fetchSucceeded(products: self.products)
        } catch(let error) {
            // Handle error here
            delegate?.fetchFailed(error: error)
        }
    }
        @MainActor
        func restore() async {
            var restored: [Transaction] = []
            for await result in Transaction.currentEntitlements {
                switch result {
                case .verified(let transaction):
                    delegate?.restoredSucceeded(transaction: transaction)
                    restored.append(transaction)
                case .unverified(_, let error):
                    delegate?.restoreFailed(error: error)
                }
            }
            if restored.isEmpty {
                delegate?.restoreFailed(error: NSError())
            }
        }
        @MainActor
        func purchase(product: Product) async {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verificationResult):
                    switch verificationResult {
                    case .verified(let transaction):
                        delegate?.purchaseSucceeded(transaction: transaction)
                        await transaction.finish()
                    case .unverified(_, let error):
                        delegate?.purchaseFailed(error: error)
                    }
                case .userCancelled:
                    delegate?.purchaseFailed( error: NSError())
                case .pending:
                    delegate?.purchaseFailed(error: NSError())
                @unknown default:
                    delegate?.purchaseFailed(error: NSError())
                }
            } catch {
                delegate?.purchaseFailed(error: error)
            }
        }
        func startTransactionListener() {
            Task.detached(priority: .background) {
                for await verificationResult in Transaction.updates {
                    switch verificationResult {
                    case .verified(let transaction):
                        await self.delegate?.transactionListener(transaction: transaction, error: nil)
                        await transaction.finish()
                    case .unverified(let transaction, let error):
                        await self.delegate?.transactionListener(transaction: transaction , error: error)
                        
                    }
                }
            }
        }
}
