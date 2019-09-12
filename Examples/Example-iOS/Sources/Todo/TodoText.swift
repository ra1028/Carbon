import UIKit
import Carbon

struct TodoText: IdentifiableComponent, Deletable {
    enum Event {
        case toggleCompleted
        case delete
    }

    var todo: Todo
    var isCompleted: Bool
    var onEvent: (Event) -> Void

    var id: Todo.ID {
        todo.id
    }

    func renderContent() -> TodoTextContent {
        .loadFromNib()
    }

    func render(in content: TodoTextContent) {
        let attributes = isCompleted ? [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        content.textLabel.attributedText = NSAttributedString(string: todo.text, attributes: attributes)
        content.completeButton.isSelected = isCompleted
        content.onToggleCompleted = {
            self.onEvent(.toggleCompleted)
        }
    }

    func delete() {
        onEvent(.delete)
    }
}

final class TodoTextContent: UIView, NibLoadable {
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var completeButton: UIButton!

    var onToggleCompleted: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        completeButton.addTarget(self, action: #selector(toggleCompleted), for: .touchUpInside)
    }

    @objc func toggleCompleted() {
        onToggleCompleted?()
    }
}
