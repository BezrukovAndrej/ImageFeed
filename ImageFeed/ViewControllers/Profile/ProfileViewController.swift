import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Profile_image") ?? UIImage()
        imageView.contentMode = .scaleAspectFill
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
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addSubviews()
        addConstraints()
        
        updateProfileDetails(with: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
        updateAvatar()
    }
    
    @objc private func logoutButtonTapped() {
        
    }
    
    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.nicknameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.setImage(with: url)
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
}

private extension ProfileViewController {
    func addSubviews() {
        [avatarImageView, nameLabel, nicknameLabel, descriptionLabel, logoutButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
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
