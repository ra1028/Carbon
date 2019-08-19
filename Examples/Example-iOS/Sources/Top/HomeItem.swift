import UIKit
import Carbon

struct HomeItem: IdentifiableComponent {
    var title: String
    var onSelect: () -> Void

    var id: String {
        return title
    }

    func renderContent() -> HomeItemContent {
        return .loadFromNib()
    }

    func render(in content: HomeItemContent) {
        content.titleLabel.text = title
        content.onSelect = onSelect
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 70)
    }
}

final class HomeItemContent: UIControl, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var indicatorImageView: UIImageView!

    var onSelect: (() -> Void)?

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .secondaryBlack : .primaryBlack
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        indicatorImageView.image = indicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }

    @objc private func selected() {
        onSelect?()
    }
}
