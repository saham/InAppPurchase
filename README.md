
## In-App Purchase
This is a general singleton In-App Purchase Manager that can be shared between apps or mutiple places in one app.
You need to have a case for each ProductID
```
enum ProductId:String, CaseIterable {
    // User defined and must be the same as AppStoreConnect
    case Prod1 = "com.Prod1"
    case Prod2 = "com.Prod2"
    case Prod3 = "com.Prod3"
}
```

### How to use

Below is how you can add IAPManager to your app.

1. Just add `IAPManager.swift` to your project
2. Make sure Target Membership is selected

![IAPManager](https://user-images.githubusercontent.com/4553478/219778126-4e843df4-6faf-4e1c-9254-dcc35fdef3d5.jpeg)



3 Fetch Produts as soon as possible. We recommend the following in `AppDelegate.swift`
   ```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IAPManger.shared.fetchProducts()
        ....
        return true
   }
   ```
### Example
<img width="290" alt="IAP Example" src="https://user-images.githubusercontent.com/4553478/219787604-770a8c79-52c7-4278-85eb-f2b56ccd0131.png">

