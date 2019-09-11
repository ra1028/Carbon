import UIKit
import Carbon

struct FormTextPicker: Component {
    var texts: [String]
    var onSelect: (String) -> Void

    func renderContent() -> FormTextPickerContent {
        .loadFromNib()
    }

    func render(in content: FormTextPickerContent) {
        content.texts = texts
        content.onSelect = onSelect
    }

    func shouldRender(next: FormTextPicker, in content: FormTextPickerContent) -> Bool {
        texts != next.texts
    }
}

final class FormTextPickerContent: UIView, NibLoadable, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }

    var texts = [String]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var onSelect: ((String) -> Void)?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        texts.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: texts[row], attributes: [.foregroundColor: UIColor.label])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelect?(texts[row])
    }
}
