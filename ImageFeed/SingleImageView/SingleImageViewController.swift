import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageFullScreen.image = image
        }
    }
    
    @IBOutlet weak var imageFullScreen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFullScreen.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
