import Foundation
import StoreKit

@objc protocol IAPHandlerDelegate {
    func transactionStatus(transaction: SKPaymentTransaction)
}
class IAPManager: NSObject, SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            delegate?.transactionStatus(transaction: transaction)
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing...")
            case .purchased,.failed,.restored,.deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
            @unknown default:
                break
            }
        }
    }
    // MARK: - Variables
    var products:[SKProduct] = []
    var delegate:IAPHandlerDelegate?
    var productBeingPurchased: SKProduct?
    static let shared = IAPManager()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {return}
        products = response.products
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
        guard request is SKProductsRequest else {return}
        
    }
    
    func getSortedProducts()->[SKProduct] {
        // You can customize to return subset of products
        return self.products.sorted(by: {$0.price.floatValue < $1.price.floatValue})
    }
    
    public func fetchProducts() {
        // Call this as soon as possible.
        // AppDelegate.swift is recommended
        let request = SKProductsRequest(productIdentifiers: Set(ProductId.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    public func purchase(product: SKProduct,quantity: Int = 1) {
        // Call to purchase
        guard SKPaymentQueue.canMakePayments() else {return}
        productBeingPurchased = product
        let payment = SKMutablePayment(product: product)
        if quantity > 0 {
            payment.quantity = quantity
        }
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restore() {
        // Call to restore all previously purchased none consumable products
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

enum ProductId:String, CaseIterable {
    // User defined and must the same as AppStoreConnect
    case Prod1 = "com.Prod1"
    case Prod2 = "com.Prod2"
    case Prod3 = "com.Prod3"
}
extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    var localizedPrice: String {
        if self.price == 0.00 {
            return "Free"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale
            guard let formattedPrice = formatter.string(from: self.price) else {
                return "Unknown Price"
            }
            return formattedPrice
        }
    }
}
