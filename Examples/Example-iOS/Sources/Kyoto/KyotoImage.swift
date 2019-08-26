import UIKit
import Carbon

struct KyotoImage: IdentifiableComponent, Hashable {
    var title: String
    var image: UIImage

    func renderContent() -> KyotoImageContent {
        return .loadFromNib()
    }

    func render(in content: KyotoImageContent) {
        content.imageView.image = image
        content.titleLabel.text = title
    }
}

final class KyotoImageContent: UIView, NibLoadable {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
