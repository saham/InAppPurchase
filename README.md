
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

<img width="262" alt="Screenshot 2023-02-27 at 8 43 50 PM" src="https://user-images.githubusercontent.com/4553478/221731300-9292d994-b7f3-4159-94c1-438e34f72692.png">




3 Fetch Produts as soon as possible. We recommend the following in `AppDelegate.swift`
   ```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IAPManger.shared.fetchProducts()
        ....
        return true
   }
   ```
### Example


![Simulator Screen Shot - iPhone 14 Pro - 2023-02-27 at 20 43 31](https://user-images.githubusercontent.com/4553478/221731452-a74d1b07-3c62-44a0-9659-60277abc413e.png)


### Donation

If you liked this free repository, you can ![BuyMeACofee] (https://www.buymeacoffee.com/NovaNext)
