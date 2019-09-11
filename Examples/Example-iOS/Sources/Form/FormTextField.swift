import UIKit
import Carbon

struct FormTextField: IdentifiableComponent {
    var title: String
    var text: String?
    var keyboardType: UIKeyboardType
    var onInput: (String?) -> Void

    init(title: String, text: String?, keyboardType: UIKeyboardType = .default, onInput: @escaping (String?) -> Void) {
        self.title = title
        self.text = text
        self.keyboardType = keyboardType
        self.onInput = onInput
    }

    var id: String {
        title
    }

    func renderContent() -> FormTextFieldContent {
        .loadFromNib()
    }

    func render(in content: FormTextFieldContent) {
        if !content.textField.isFirstResponder {
            content.textField.text = text
        }

        content.titleLabel.text = title
        content.textField.keyboardType = keyboardType
        content.onInput = onInput
    }
}

final class FormTextFieldContent: UIControl, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!

    var onInput: ((String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        addTarget(self, action: #selector(selected), for: .touchUpInside)
        textField.addTarget(self, action: #selector(input), for: .allEditingEvents)
    }

    @objc func selected() {
        textField.becomeFirstResponder()
    }

    @objc func input() {
        onInput?(textField.text)
    }
}
