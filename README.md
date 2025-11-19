
## InAppPurchaseManager
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

Below is how you can add InAppPurchaseManager to your app.

1. Just add `InAppPurchaseManager.swift` to your project
2. Fetch Produts as soon as possible. We recommend the following in `AppDelegate.swift`
   ```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         InAppPurchaseManager.shared.startTransactionListener()
        Task{
            await InAppPurchaseManager.shared.fetchProducts()
        }
        ....
        return true
   }
   ```
### Example


![Simulator Screen Shot - iPhone 14 Pro - 2023-02-27 at 20 43 31](https://user-images.githubusercontent.com/4553478/221731452-a74d1b07-3c62-44a0-9659-60277abc413e.png)


### Donation

If you liked this free repository, you can [Buy me a coffee](https://www.buymeacoffee.com/NovaNext)
