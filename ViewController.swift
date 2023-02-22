import StoreKit
import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    var Products:[SKProduct] = []
    var SelectedProduct: SKProduct?

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - IBAction
    @IBAction func Buy(_ sender: UIButton) {
        if let productToBuy = SelectedProduct {
            IAPManager.shared.purchase(product: productToBuy)
        }
    }

    @IBAction func Restore(_ sender: UIButton) {
        IAPManager.shared.restore()
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Products = IAPManager.shared.products
        SelectedProduct = Products.first
        tableView.delegate = self
        tableView.dataSource = self
        IAPManager.shared.delegate = self
    }
}
// MARK: - tableView Delegate and DataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Products.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedProduct = Products[indexPath.row]
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = Products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = product.localizedDescription
        cell.detailTextLabel?.text = product.localizedPrice
        cell.accessoryType = SelectedProduct == product ? .checkmark : .none
        return cell
    }
}

// MARK: - IAPManager Delegate
extension ViewController: IAPHandlerDelegate {
    func status(transaction: SKPaymentTransaction) {
        // Implement this. You can use this to update the UI
switch transaction.transactionState {
        case .restored:
            print("Transaction restored")
        case .deferred:
            print("Transaction deferred")
        case .purchasing:
            print("Transaction being purchased")
        case .purchased:
            print("Transaction purchased")
        case .failed:
            print("Transaction faild")
        default:
            break
        }
    }
}
