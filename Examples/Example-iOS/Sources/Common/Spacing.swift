import UIKit
import Carbon

struct Spacing: IdentifiableComponent, Hashable {
    var height: CGFloat

    func renderContent() -> UIView {
        return UIView()
    }

    func render(in content: UIView) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: height)
    }
}
