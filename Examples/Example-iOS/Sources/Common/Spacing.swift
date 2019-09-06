import UIKit
import Carbon

struct Spacing: Component {
    var height: CGFloat

    init(_ height: CGFloat) {
        self.height = height
    }

    func renderContent() -> UIView {
        return UIView()
    }

    func render(in content: UIView) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: height)
    }
}
