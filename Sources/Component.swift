import UIKit

/// A component represents a small reusable piece of code of element to be rendered.
/// This behaves as all elements of UIKit's UITableView and UICollectionView, and can
/// be easily support SwiftUI by used in conjunction with the `View` protocol.
///
/// Example for the simple component:
///
///     struct Label: Component {
///         var text: String
///
///         init(_ text: String) {
///             self.text = text
///         }
///
///         func renderContent() -> UILabel {
///             return UILabel()
///         }
///
///         func render(in content: UILabel) {
///             content.text = text
///         }
///     }
///
/// Example for use with SwiftUI:
///
///     extension Label: View {}
///
///     struct ContentView: View {
///         var body: some View {
///             VStack {
///                 Text("This is SwiftUI view")
///                 Label("This is Carbon component")
///             }
///         }
///     }
public protocol Component {
    /// A type that represents a content to be render on the element of list UI.
    associatedtype Content

    // MARK: - Rendering - required

    /// Returns a new instance of `Content`.
    ///
    /// - Returns: A new `Content` instance.
    func renderContent() -> Content

    /// Render properties into the content.
    ///
    /// - Parameter:
    ///   - content: An instance of `Content` laid out on the element of list UI.
    func render(in content: Content)

    // MARK: - Rendering - optional

    /// A string used to identify a element that is reusable. Default is the type name of `self`.
    var reuseIdentifier: String { get }

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
    func referenceSize(in bounds: CGRect) -> CGSize?

    /// Returns a `Bool` value indicating whether the content should be reloaded.
    ///
    /// - Note: Unlike `Equatable`, this doesn't compare whether the two values
    ///         exactly equal. It's can be ignore property comparisons, if not expect
    ///         to reload content.
    ///
    /// - Parameter:
    ///   - next: The next value to be compared to the receiver.
    ///
    /// - Returns: A `Bool` value indicating whether the content should be reloaded.
    func shouldContentUpdate(with next: Self) -> Bool

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    func shouldRender(next: Self, in content: Content) -> Bool

    /// Layout the content on top of element of the list UI.
    ///
    /// - Note: `UIView` and `UIViewController` are laid out with edge constraints by default.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    func layout(content: Content, in container: UIView)

    /// The natural size for the passed content.
    ///
    /// - Parameter:
    ///   - content: An instance of content.
    ///
    /// - Returns: A `CGSize` value represents a natural size of the passed content.
    func intrinsicContentSize(for content: Content) -> CGSize

    // MARK: - Lifecycle - optional

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    func contentWillDisplay(_ content: Content)

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    func contentDidEndDisplay(_ content: Content)
}

public extension Component {
    /// A string used to identify a element that is reusable. Default is the type name of `self`.
    @inlinable
    var reuseIdentifier: String {
        return String(reflecting: Self.self)
    }

    /// Returns the referencing size of content to render on the list UI. Returns nil by default.
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
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return nil
    }

    /// Returns a `Bool` value indicating whether the content should be reloaded. Default is false.
    ///
    /// - Note: Unlike `Equatable`, this doesn't compare whether the two values
    ///         exactly equal. It's can be ignore property comparisons, if not expect
    ///         to reload content.
    ///
    /// - Parameter:
    ///   - next: The next value to be compared to the receiver.
    ///
    /// - Returns: A `Bool` value indicatig whether the content should be reloaded.
    @inlinable
    func shouldContentUpdate(with next: Self) -> Bool {
        return false
    }

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    @inlinable
    func shouldRender(next: Self, in content: Content) -> Bool {
        return true
    }

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    @inlinable
    func contentWillDisplay(_ content: Content) {}

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    @inlinable
    func contentDidEndDisplay(_ content: Content) {}
}

public extension Component where Content: UIView {
    /// Layout the content on top of element of the list UI.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    ///                Default is laid out with edge constraints.
    func layout(content: Content, in container: UIView) {
        container.addSubviewWithEdgeConstraints(content)
    }

    /// The natural size for the passed content.
    ///
    /// - Parameter:
    ///   - content: An instance of content.
    ///
    /// - Returns: A `CGSize` value represents a natural size of the passed content.
    func intrinsicContentSize(for content: Content) -> CGSize {
        return content.intrinsicContentSize
    }
}

public extension Component where Content: UIViewController {
    /// Layout the content on top of element of the list UI.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    ///                Default is laid out with edge constraints.
    func layout(content: Content, in container: UIView) {
        container.addSubviewWithEdgeConstraints(content.view)
    }

    /// The natural size for the passed content.
    ///
    /// - Parameter:
    ///   - content: An instance of content.
    ///
    /// - Returns: A `CGSize` value represents a natural size of the passed content.
    func intrinsicContentSize(for content: Content) -> CGSize {
        return content.view.intrinsicContentSize
    }
}

private extension UIView {
    func addSubviewWithEdgeConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor)

        // Setting the priority lower than `UILayoutPriority.required` prevents
        // header view from becoming an ambiguous constraint.
        // This may cause other unknown layout failures.
        // If you can found it, please report it by GitHub issue.
        let priority = UILayoutPriority(999)
        bottomConstraint.priority = priority
        trailingConstraint.priority = priority

        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomConstraint,
            trailingConstraint
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
