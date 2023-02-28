import UIKit
import StoreKit
class ViewController: UIViewController {
    
    // MARK: - Variables
    var products:[SKProduct] = []
    var selectedProduct: SKProduct?
    var ProductBeingPurchased: SKProduct?
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    @IBAction func buyPressed(_ sender: UIButton) {
        self.ProductBeingPurchased = selectedProduct
        if let productToBuy = selectedProduct {
            IAPManager.shared.purchase(product: productToBuy)
        }
    }
    
    @IBAction func restorePressed(_ sender: UIButton) {
        IAPManager.shared.restore()
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        products = IAPManager.shared.getSortedProducts()
        selectedProduct = products.first
        tableView.delegate = self
        tableView.dataSource = self
        IAPManager.shared.delegate = self
    }
}
// MARK: - tableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.textLabel?.text = product.productIdentifier // To demo. It's not recommended to show  productIdentifier to End User
        cell.detailTextLabel?.text = product.localizedPrice
        cell.accessoryType = product == selectedProduct ? .checkmark : .none
        return cell
    }
    
}
// MARK: - IAPManager Delegate
extension ViewController: IAPHandlerDelegate {
    func transactionStatus(transaction: SKPaymentTransaction) {
        // You can update UI in here
        switch transaction.transactionState {
        case .purchasing:
            print("purchasing")
        case .purchased:
            guard transaction.payment.productIdentifier == self.ProductBeingPurchased?.productIdentifier else {return}
            print("purchased")
        case .failed:
            print("failed")
        case .restored:
            print("restored")
        case .deferred:
            print("deferred")
        @unknown default:
            print("unknown")
        }
    }
}
