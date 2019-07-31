import UIKit
import Carbon

struct KyotoTop: Component, Equatable {
    func renderContent() -> KyotoTopContent {
        return .loadFromNib()
    }

    func render(in content: KyotoTopContent) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return nil
    }
}

final class KyotoTopContent: UIView, NibLoadable {}
