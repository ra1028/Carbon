import UIKit
import Carbon

struct Footer: Component, Equatable {
    var text: String

    func renderContent() -> FooterContent {
        return .loadFromNib()
    }

    func render(in content: FooterContent) {
        content.textLabel.text = text
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 64)
    }
}

final class FooterContent: UIView, NibLoadable {
    @IBOutlet var textLabel: UILabel!
}
