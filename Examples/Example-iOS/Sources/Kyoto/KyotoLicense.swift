import SwiftUI
import Carbon

struct KyotoLicense: Component, View {
    var onSelected: () -> Void

    func renderContent() -> KyotoLicenseContent {
        .loadFromNib()
    }

    func render(in content: KyotoLicenseContent) {
        content.onSelected = onSelected
    }
}

final class KyotoLicenseContent: UIControl, NibLoadable {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray4 : .clear
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
