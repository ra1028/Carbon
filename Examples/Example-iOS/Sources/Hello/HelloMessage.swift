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
}

final class HelloMessageContent: UIView, NibLoadable {
    @IBOutlet var label: UILabel!
}
