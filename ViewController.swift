import StoreKit
import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    var Products:[SKProduct] = []
    var SelectedProd: SKProduct?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Products = IAPManger.shared.products
        SelectedProd = Products.first
        tableView.delegate = self
        tableView.dataSource = self
        IAPManger.shared.delegate = self
    }

    // MARK: - IBAction
    @IBAction func Buy(_ sender: UIButton) {
        if let productToBuy = SelectedProd {
            IAPManger.shared.purchase(product: productToBuy)
        }
    }
    @IBAction func Restore(_ sender: UIButton) {
        IAPManger.shared.restore()
    }
}
// MARK: - tableView Delegate and Datasource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Products.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedProd = Products[indexPath.row]
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = Products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = product.localizedDescription
        cell.detailTextLabel?.text = "\(product.price)"
        cell.accessoryType = SelectedProd == product ? .checkmark : .none
        return cell
    }
}

// MARK: - IAPManager Delegate
extension ViewController: IAPHandlerDelegate {
    func status(transaction: SKPaymentTransaction) {
        // Implement this
    }
}
