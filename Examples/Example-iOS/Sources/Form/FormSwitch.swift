import UIKit
import Carbon

struct FormSwitch: IdentifiableComponent {
    var title: String
    var isOn: Bool
    var onSwitch: (Bool) -> Void

    var id: String {
        title
    }

    func renderContent() -> FormSwitchContent {
        .loadFromNib()
    }

    func render(in content: FormSwitchContent) {
        content.titleLabel.text = title
        content.switch.isOn = isOn
        content.onSwitch = onSwitch
    }
}

final class FormSwitchContent: UIView, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var `switch`: UISwitch!

    var onSwitch: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.switch.addTarget(self, action: #selector(switched), for: .valueChanged)
    }

    @objc func switched() {
        onSwitch?(self.switch.isOn)
    }
}
