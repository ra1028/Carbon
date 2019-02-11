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
        return todo.id
    }

    func renderContent() -> TodoTextContent {
        return .loadFromNib()
    }

    func render(in content: TodoTextContent) {
        let attributes = isCompleted ? [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        content.textLabel.attributedText = NSAttributedString(string: todo.text, attributes: attributes)
        content.completeButton.isSelected = isCompleted
        content.onToggleCompleted = {
            self.onEvent(.toggleCompleted)
        }
    }

    func shouldContentUpdate(with next: TodoText) -> Bool {
        return todo != next.todo
            || isCompleted != next.isCompleted
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return nil
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
