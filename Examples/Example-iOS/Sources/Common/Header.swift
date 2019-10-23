import SwiftUI
import Carbon

struct Header: Component, View {
    var title: String

    init(_ title: String) {
        self.title = title
    }

    func renderContent() -> HeaderContent {
        .loadFromNib()
    }

    func render(in content: HeaderContent) {
        content.titleLabel.text = title
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        CGSize(width: bounds.width, height: 64)
    }
}

final class HeaderContent: UIView, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
}
