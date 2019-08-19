import UIKit
import Carbon

struct FormDatePicker: Component {
    var date: Date
    var onSelect: (Date) -> Void

    func renderContent() -> FormDatePickerContent {
        return .loadFromNib()
    }

    func render(in content: FormDatePickerContent) {
        content.datePicker.date = date
        content.onSelect = onSelect
    }

    func shouldRender(next: FormDatePicker, in content: FormDatePickerContent) -> Bool {
        return false
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 194)
    }
}

final class FormDatePickerContent: UIView, NibLoadable {
    @IBOutlet var datePicker: UIDatePicker!

    var onSelect: ((Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        datePicker.setValue(UIColor.primaryWhite, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(selected), for: .valueChanged)
    }

    @objc func selected() {
        onSelect?(datePicker.date)
    }
}
