import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private lazy var avatarImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Profile_image") ?? UIImage()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .ypWhite
            imageView.tintColor = .ypGray
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 35
            return imageView
        }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        applyStyleLabel(label, text: "Hello, world!")
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        applyStyleLabel(label, text: "@ekaterina_nov", textColor: .gray)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        applyStyleLabel(label, text: "Екатерина Новикова", font: UIFont.systemFont(ofSize: 23, weight: .bold))
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
    private var gradientViews = Set<UIView>()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        addSubviews()
        addConstraints()
        createGradient()
        
        updateProfileDetails(with: profileService.profile)
        updateAvatar()
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .cancel) { [weak self] _ in
            guard let self = self else { return assertionFailure("Impossible get a weak self") }
            self.oauth2TokenStorage.removeToken()
            self.cleanCache()
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        yesAction.accessibilityIdentifier = "Yes"
        let noAction = UIAlertAction(title: "Нет", style: .default)
        [yesAction, noAction].forEach { item in
            alert.addAction(item)
        }
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        self.present(alert, animated: true)
    }
    
    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.nicknameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let sfSymbolName = "person.crop.circle.fill"
        
        let sizeSfSymbol = UIImage.SymbolConfiguration(pointSize: 70.0)
        guard let imageA = UIImage(systemName: sfSymbolName, withConfiguration: sizeSfSymbol)?.withTintColor(.ypGray, renderingMode: .alwaysOriginal) else {
            return assertionFailure("Could not load SF Symbol: \(sfSymbolName)!" )
        }
        
        guard let cgRef = imageA.cgImage else {
            return assertionFailure("Could not get cgImage!")
        }
        let imageB = UIImage(cgImage: cgRef, scale: imageA.scale, orientation: imageA.imageOrientation)
            .withTintColor(.ypGray, renderingMode: .alwaysOriginal)
        let placeholder = imageB
        placeholder.withTintColor(.ypWhite)
        
        avatarImageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.removeGradient()
        }
    }
    
    private func createGradient() {
        let avatarGradientView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 70)))
        let nameGradientView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 235, height: 28)))
        let nicknameGradientView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 18)))
        
        
        [avatarGradientView, nameGradientView, nicknameGradientView].forEach {
            $0.applyGradientWithAnimation()
            gradientViews.insert($0)
        }
        
        avatarImageView.addSubview(avatarGradientView)
        nicknameLabel.addSubview(nicknameGradientView)
        nameLabel.addSubview(nameGradientView)
    }
    
    private func removeGradient() {
        gradientViews.forEach { $0.removeGradientWithAnimation()}
    }
    
// MARK: - Supporting method
    
    private func applyStyleLabel(
        _ label: UILabel,
        text: String = "",
        font: UIFont? = UIFont.systemFont(ofSize: 13),
        textColor: UIColor = .ypWhite
    ){
        label.text = text
        label.font = font
        label.textColor = textColor
    }
    
    private func cleanCache() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

private extension ProfileViewController {
    func addSubviews() {
        [avatarImageView, nameLabel, nicknameLabel, descriptionLabel, logoutButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
}

// MARK: - Set Constraints

extension ProfileViewController {
    func addConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
