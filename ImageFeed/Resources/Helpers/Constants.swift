import UIKit

struct DecodingInfo {
    struct API {
       static let accessKey = "JJ8eMw9mODPvSAhwi44jkw9QZoP2Jc-ZvyrcwnBtfHk"
       static let secretKey = "mKK1UATME8SQXLGFqDvPzX65azBUhFSx14qQ0sJuJgE"
       static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
       static let accessScope = "public+read_user+write_likes"
       static let defaultBaseURL = "https://api.unsplash.com"
       static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    struct IB {
       static let webViewSegueIdentifier = "ShowWebView"
       static let tabBarControllerIdentifier = "TabBarViewController"
       static let authViewControllerIdentifier = "AuthViewController"
    }
}
