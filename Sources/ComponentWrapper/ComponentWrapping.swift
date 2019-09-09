import UIKit

@dynamicMemberLookup
public protocol ComponentWrapping: Component {
    associatedtype Wrapped: Component

    var wrapped: Wrapped { get }
}

public extension ComponentWrapping {
    subscript<T>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T {
        wrapped[keyPath: keyPath]
    }

    var reuseIdentifier: String {
        wrapped.reuseIdentifier
    }

    func renderContent() -> Wrapped.Content {
        wrapped.renderContent()
    }

    func render(in content: Wrapped.Content) {
        wrapped.render(in: content)
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        wrapped.referenceSize(in: bounds)
    }

    func shouldContentUpdate(with next: Self) -> Bool {
        wrapped.shouldContentUpdate(with: next.wrapped)
    }

    func shouldRender(next: Self, in content: Wrapped.Content) -> Bool {
        wrapped.shouldRender(next: next.wrapped, in: content)
    }

    func layout(content: Wrapped.Content, in container: UIView) {
        wrapped.layout(content: content, in: container)
    }

    func contentWillDisplay(_ content: Wrapped.Content) {
        wrapped.contentWillDisplay(content)
    }

    func contentDidEndDisplay(_ content: Wrapped.Content) {
        wrapped.contentDidEndDisplay(content)
    }
}
