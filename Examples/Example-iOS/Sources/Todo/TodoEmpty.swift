import UIKit
import Carbon

struct TodoEmpty: Component {
    func renderContent() -> TodoEmptyContent {
        return .loadFromNib()
    }

    func render(in content: TodoEmptyContent) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 150)
    }
}

final class TodoEmptyContent: UIView, NibLoadable {
    @IBOutlet var textLabel: UILabel!
}
