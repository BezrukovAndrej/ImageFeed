import UIKit

final class SplashViewController: UIViewController {
    private var oAuth2TokenStorage = OAuth2TokenStorage()
    private var oAuth2Service = OAuth2Service()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage().token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: DecodingInfo.IB.authViewSegueIdentifier, sender: nil)
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DecodingInfo.IB.authViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(DecodingInfo.IB.authViewSegueIdentifier)")}
            viewController.delegate = self 
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first
        else { fatalError("Invalid Configuration ") }
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main
        )
            .instantiateViewController(
                withIdentifier: DecodingInfo.IB.tabBarId
            )
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.oAuth2Service.fetchAuthToken(code: code) { result in
                switch result {
                case.success(let response):
                    self.oAuth2TokenStorage.token = response.accessToken
                    self.switchToTabBarController()
                case.failure:
                    
                    break
                }
            }
        }
    }
}
