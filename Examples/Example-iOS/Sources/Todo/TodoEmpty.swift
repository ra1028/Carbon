import UIKit
import Carbon

struct TodoEmpty: IdentifiableComponent, Hashable {
    func renderContent() -> TodoEmptyContent {
        .loadFromNib()
    }

    func render(in content: TodoEmptyContent) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        CGSize(width: bounds.width, height: 150)
    }
}

final class TodoEmptyContent: UIView, NibLoadable {
    @IBOutlet var textLabel: UILabel!
}
