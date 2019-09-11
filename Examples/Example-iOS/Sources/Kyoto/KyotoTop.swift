import UIKit
import Carbon

struct KyotoTop: Component, Hashable {
    func renderContent() -> KyotoTopContent {
        .loadFromNib()
    }

    func render(in content: KyotoTopContent) {}
}

final class KyotoTopContent: UIView, NibLoadable {}
