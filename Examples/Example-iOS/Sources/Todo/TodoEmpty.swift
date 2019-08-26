import UIKit
import Carbon

struct TodoEmpty: Component {
    func renderContent() -> TodoEmptyContent {
        return .loadFromNib()
    }

    func render(in content: TodoEmptyContent) {}
}

final class TodoEmptyContent: UIView, NibLoadable {
    @IBOutlet var textLabel: UILabel!
}
