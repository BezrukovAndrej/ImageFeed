import UIKit

struct DecodingInfo {
    struct API {
       static let accessKey = "oiafulFY5Ta5sGz8hagfaxNbF9n3cthuUbnpWwwOy9w"
       static let secretKey = "vgfqMhFxkXdADReelLnTN7jHSTgnLpt-sctKE-coEZs"
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
