import SwiftUI
import Carbon

struct KyotoImage: IdentifiableComponent, View, Hashable {
    var title: String
    var image: UIImage

    func renderContent() -> KyotoImageContent {
        .loadFromNib()
    }

    func render(in content: KyotoImageContent) {
        content.imageView.image = image
        content.titleLabel.text = title
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        CGSize(width: bounds.width, height: 150)
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
