import Carbon
import UIKit

struct PangramLabel: IdentifiableComponent, Hashable {
    var text: String

    func renderContent() -> UILabel {
        let label = UILabel()
        label.textColor = .primaryGreen
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor.primaryWhite.withAlphaComponent(0.1)
        return label
    }

    func render(in content: UILabel) {
        content.text = text
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: 30, height: 30)
    }
}
