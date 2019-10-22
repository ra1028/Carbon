import SwiftUI
import Carbon

struct KyotoTop: Component, View, Hashable {
    func renderContent() -> KyotoTopContent {
        .loadFromNib()
    }

    func render(in content: KyotoTopContent) {}
}

final class KyotoTopContent: UIView, NibLoadable {}
