
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
