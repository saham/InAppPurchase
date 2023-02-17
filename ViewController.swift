import UIKit
import StoreKit
class ViewController: UIViewController, SKRequestDelegate {
    
    @IBAction func RestorePressed(_ sender: UIButton) {
        IAPManger.shared.restore()
    }
    
    @IBAction func BuyPressed(_ sender: UIButton) {
        if let productToBuy = IAPManger.shared.getSortedProducts().first{
            // Assume we buy first product
            IAPManger.shared.purchase(product: productToBuy)
        }
    }

    // MARK: - view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    // MARK: - Functions
}
extension BuyRestoreViewController: IAPHandlerDelegate {
    func transactionStatus(transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .restored:
            // Your code to update UI/Your Backend, etc...
        case .deferred:
            guard transaction.payment.productIdentifier == IAPManger.shared.productBeingPurchased?.productIdentifier else {return}
            // Your code to update UI/Your Backend, etc...
        case .purchasing:
            // Your code to update UI/Your Backend, etc...
           break
        case .purchased:
            // Your code to update UI/Your Backend, etc...
        case .failed:
            // Your code to update UI/Your Backend, etc...
        default:
            break
        }
    }
}

