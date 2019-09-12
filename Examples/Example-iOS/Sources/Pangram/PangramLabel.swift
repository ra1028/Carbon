import Carbon
import UIKit

struct PangramLabel: IdentifiableComponent, Hashable {
    var text: String

    func renderContent() -> UILabel {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.backgroundColor = UIColor.systemGray6
        return label
    }

    func render(in content: UILabel) {
        content.text = text
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        CGSize(width: 30, height: 30)
    }
}
