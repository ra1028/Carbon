import UIKit
import Carbon

struct FormLabel: IdentifiableComponent {
    var title: String
    var text: String?
    var onSelect: () -> Void

    var id: String {
        return title
    }

    func renderContent() -> FormLabelContent {
        return .loadFromNib()
    }

    func render(in content: FormLabelContent) {
        content.titleLabel.text = title
        content.textLabel.text = text
        content.onSelect = onSelect
    }

    func shouldContentUpdate(with next: FormLabel) -> Bool {
        return title != next.title
            || text != next.text
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 44)
    }
}

final class FormLabelContent: UIControl, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!

    var onSelect: (() -> Void)?

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .primaryBlack : .secondaryBlack
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }

    @objc func selected() {
        onSelect?()
    }
}
