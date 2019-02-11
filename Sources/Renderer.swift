import UIKit

/// Renderer is a controller to render passed data to target
/// immediately using specific adapter and updater.
///
/// Its behavior can be changed by using other type of adapter,
/// updater, or by customizing it.
///
/// Example for render a section containing simple nodes.
///
///     let renderer = Renderer(
///         target: tableView,
///         adapter: UITableViewAdapter(),
///         updater: UITableViewUpdater()
///     )
///
///     renderer.render(
///         Section(
///             id: "section",
///             header: ViewNode(Label(text: "header")),
///             cells: [
///                 CellNode(id: 0, component: Label(text: "cell 0")),
///                 CellNode(id: 1, component: Label(text: "cell 1")),
///                 CellNode(id: 2, component: Label(text: "cell 2"))
///             ],
///             footer: ViewNode(Label(text: "footer"))
///         )
///     )
open class Renderer<Updater: Carbon.Updater> {
    /// An instance of target that weakly referenced.
    public private(set) weak var target: Updater.Target?

    /// An instance of adapter that specified at initialized.
    public let adapter: Updater.Adapter

    /// An instance of updater that specified at initialized.
    public let updater: Updater

    /// Returns a current data held in adapter.
    /// When data is set, it renders to the target immediately.
    open var data: [Section] {
        get { return adapter.data }
        set(data) { render(data) }
    }

    /// Create a new instance with given target, adapter and updater.
    /// Immediately the `prepare` of updater is called.
    public init(target: Updater.Target, adapter: Updater.Adapter, updater: Updater) {
        self.target = target
        self.adapter = adapter
        self.updater = updater

        updater.prepare(target: target, adapter: adapter)
    }

    /// Render given collection of sections, immediately.
    ///
    /// - Parameters:
    ///   - data: A collection of sections to be rendered.
    ///   - completion: A completion handler to be called after rendered.
    open func render<C: Collection>(_ data: C, completion: (() -> Void)? = nil) where C.Element == Section {
        guard let target = target else {
            completion?()
            return
        }

        updater.performUpdates(target: target, adapter: adapter, data: Array(data), completion: completion)
    }

    /// Render given collection of sections after removes contained nil, immediately.
    ///
    /// - Note: It's rendered with nil removed from the passed collection of sections.
    ///
    /// - Parameters:
    ///   - data: A collection of sections to be rendered that can be contains nil.
    ///   - completion: A completion handler to be called after rendered.
    open func render<C: Collection>(_ data: C, completion: (() -> Void)? = nil) where C.Element == Section? {
        render(data.compactMap { $0 }, completion: completion)
    }

    /// Render a given variadic number of sections, immediately.
    ///
    /// - Parameters:
    ///   - data: A variadic number of sections to be rendered.
    ///   - completion: A completion handler to be called after rendered.
    open func render(_ data: Section..., completion: (() -> Void)? = nil) {
        render(data, completion: completion)
    }

    /// Render a given variadic number of sections after removes contained nil, immediately.
    ///
    /// - Parameters:
    ///   - data: A variadic number of sections to be rendered that can be contains nil.
    ///   - completion: A completion handler to be called after rendered.
    open func render(_ data: Section?..., completion: (() -> Void)? = nil) {
        render(data.compactMap { $0 }, completion: completion)
    }
}
