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

    func shouldContentUpdate(with next: KyotoLicense) -> Bool {
        return false
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 70)
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
