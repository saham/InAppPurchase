
## InAppPurchase
1. This is a general singletone In-App Store Manger that can be shared between apps or mutiple places in one app.
You need to have a case for each ProductID
```
enum ProductId:String, CaseIterable {
    // User defined and must be the same as AppStoreConnect
    case Prod1 = "com.Prod1"
    case Prod2 = "com.Prod2"
    case Prod3 = "com.Prod3"
}
```

### Installation

Below is how you can add IAPManger to your app.

1. Just add `IAPManager.swift` to your prohject
2. Make sure Targeted Membership is selected

![IAPManager](https://user-images.githubusercontent.com/4553478/219778126-4e843df4-6faf-4e1c-9254-dcc35fdef3d5.jpeg)



3. Fetch Produts as soon as possible. We recommend the following in `AppDelegate.swift`
   ```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   IAPManger.shared.fetchProducts()
   ....
   return true
   }
   ```
### Example
<img width="290" alt="IAP Example" src="https://user-images.githubusercontent.com/4553478/219786848-6c1ea1d9-ad89-455a-860a-9f84a7ce7134.png">
