import UIKit
import StoreKit

class StoreKit2ViewController: UIViewController {
    
    var products: [Product] = []
    var selectedProduct:Product?
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func buy(_ sender: UIButton) {
        if let product = selectedProduct {
            Task{
                await InAppPurchaseManager.shared.purchase(product: product)
            }
        }
    }
    @IBAction func restore(_ sender: UIButton) {
        Task{
            await InAppPurchaseManager.shared.restore()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        InAppPurchaseManager.shared.delegate = self
    }
}
extension StoreKit2ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = self.products[indexPath.row]
        cell.textLabel?.text = product.id // To demo. It's not recommended to show  productIdentifier to End User
        cell.detailTextLabel?.text = product.localizedPrice
        cell.accessoryType = product == selectedProduct ? .checkmark : .none
        return cell
    }
}
extension StoreKit2ViewController: InAppPurchaseManagerDelegate {
    func fetchSucceeded(products: [Product]) {
        self.products = InAppPurchaseManager.shared.getProducts()
        selectedProduct = products.first
        tableView.reloadData()
    }
    
    // You can update UI in here
    func purchaseSucceeded(transaction: Transaction) {}
    func purchaseFailed(error: any Error) {}
    func restoredSucceeded(transaction: Transaction) {}
    func restoreFailed(error: any Error) {}
    func transactionListener(transaction: Transaction, error: (any Error)?) {}
    func fetchFailed(error: any Error) {}
}
extension Product {
    var localizedPrice: String {
        if self.price == 0.00 {
            return "Free"
        } else {
            let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencyCode = self.priceFormatStyle.currencyCode
                formatter.locale = self.priceFormatStyle.locale
                return formatter.string(from: self.price as NSDecimalNumber) ?? ""
        }
    }
}
