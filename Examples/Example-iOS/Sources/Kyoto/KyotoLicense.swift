import UIKit
import Carbon

struct KyotoLicense: Component {
    var onSelected: () -> Void

    func renderContent() -> KyotoLicenseContent {
        return .loadFromNib()
    }

    func render(in content: KyotoLicenseContent) {
        content.onSelected = onSelected
    }
}

final class KyotoLicenseContent: UIControl, NibLoadable {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }

    var onSelected: (() -> Void)?

    override func awakeFromNib() {
         super.awakeFromNib()

        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }

    @objc func selected() {
        onSelected?()
    }
}
