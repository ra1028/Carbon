import UIKit

///A wrapper around the component to have `referenceSize`.
public struct ReferenceSizeComponentWrapper<Wrapped: Component>: ComponentWrapping {
    /// The wrapped component instance.
    public var wrapped: Wrapped

    @usableFromInline
    internal var size: (CGRect) -> CGSize?

    /// Create a component wrapper wrapping given component and size.
    ///
    /// - Parameters:
    ///   - wrapped: A compoennt instance to be wrapped.
    ///   - size: A closure that to calculate a size of content with passed bounds.
    @inlinable
    public init(_ wrapped: Wrapped, size: @escaping (CGRect) -> CGSize?) {
        self.wrapped = wrapped
        self.size = size
    }

    /// Returns the referencing size of content to render on the list UI.
    ///
    /// - Parameter:
    ///   - bounds: A value of `CGRect` containing the size of the list UI itself,
    ///             such as `UITableView` or `UICollectionView`.
    ///
    /// - Note: Only `CGSize.height` is used to determine the size of element
    ///         in `UITableView`.
    ///
    /// - Returns: The referencing size of content to render on the list UI.
    ///            If returns nil, the element of list UI falls back to its default size
    ///            like `UITableView.rowHeight` or `UICollectionViewFlowLayout.itemSize`.
    @inlinable
    public func referenceSize(in bounds: CGRect) -> CGSize? {
        return size(bounds)
    }
}

public extension Component {
    /// Returns a component wrapping `self` having specified reference size.
    ///
    /// - Parameter
    ///   - size: A closure that to calculate a size of content with passed bounds.
    ///
    /// - Returns: A component wrapping `self` having specified reference size.
    @inlinable
    func referenceSize(_ size: @escaping (CGRect) -> CGSize?) -> ReferenceSizeComponentWrapper<Self> {
        return ReferenceSizeComponentWrapper(self, size: size)
    }

    /// Returns a component wrapping `self` having specified reference size.
    ///
    /// - Parameter
    ///   - size: The reference size of content.
    ///
    /// - Returns: A component wrapping `self` having specified reference size.
    @inlinable
    func referenceSize(_ size: @autoclosure @escaping () -> CGSize?) -> ReferenceSizeComponentWrapper<Self> {
        return ReferenceSizeComponentWrapper(self) { _ in size() }
    }

    /// Returns a component wrapping `self` having specified reference size.
    ///
    /// - Parameter
    ///   - width: The reference width of content. If passing a nil value, the width
    ///            of content is fallback to the width of boundary.
    ///   - height: The reference height of content. If passing a nil value, the height
    ///             of content is fallback to the height of boundary.
    ///
    /// - Returns: A component wrapping `self` having specified reference size.
    @inlinable
    func referenceSize(
        width: @autoclosure @escaping () -> CGFloat? = nil,
        height: @autoclosure @escaping () -> CGFloat? = nil
    ) -> ReferenceSizeComponentWrapper<Self> {
        return ReferenceSizeComponentWrapper(self) { bounds in
            CGSize(width: width() ?? bounds.width, height: height() ?? bounds.height)
        }
    }
}

#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI

@available(iOS 13.0, *)
extension ReferenceSizeComponentWrapper: View {}

#endif
