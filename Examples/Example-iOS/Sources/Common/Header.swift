import UIKit
import Carbon

struct Header: Component {
    var title: String

    func renderContent() -> HeaderContent {
        return .loadFromNib()
    }

    func render(in content: HeaderContent) {
        content.titleLabel.text = title
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 64)
    }
}

final class HeaderContent: UIView, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
}
