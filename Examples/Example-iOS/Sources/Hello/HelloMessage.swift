import UIKit
import Carbon

struct HelloMessage: IdentifiableComponent, Hashable {
    var name: String

    func renderContent() -> HelloMessageContent {
        return .loadFromNib()
    }

    func render(in content: HelloMessageContent) {
        content.label.text = "Hello \(name)"
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 44)
    }
}

final class HelloMessageContent: UIView, NibLoadable {
    @IBOutlet var label: UILabel!
}
