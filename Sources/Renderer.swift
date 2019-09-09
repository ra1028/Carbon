import UIKit

/// Renderer is a controller to render passed data to target
/// immediately using specific adapter and updater.
///
/// Its behavior can be changed by using other type of adapter,
/// updater, or by customizing it.
///
/// Example for render a section containing simple nodes.
///
///     let tableView: UITableView = ...
///     let renderer = Renderer(
///         adapter: UITableViewAdapter(),
///         updater: UITableViewUpdater()
///     )
///
///     renderer.target = tableView
///
///     renderer.render {
///         Label("Cell 1")
///             .identified(by: \.text)
///
///         Label("Cell 2")
///             .identified(by: \.text)
///
///         Label("Cell 3")
///             .identified(by: \.text)
///     }
open class Renderer<Updater: Carbon.Updater> {
    /// An instance of adapter that specified at initialized.
    public let adapter: Updater.Adapter

    /// An instance of updater that specified at initialized.
    public let updater: Updater

    /// An instance of target that weakly referenced.
    /// It will be passed to the `prepare` method of updater at didSet.
    open weak var target: Updater.Target? {
        didSet {
            guard let target = target else { return }
            updater.prepare(target: target, adapter: adapter)
        }
    }

    /// Returns a current data held in adapter.
    /// When data is set, it renders to the target immediately.
    open var data: [Section] {
        get { return adapter.data }
        set(data) { render(data) }
    }

    /// Create a new instance with given adapter and updater.
    public init(adapter: Updater.Adapter, updater: Updater) {
        self.adapter = adapter
        self.updater = updater
    }

    /// Render given collection of sections, immediately.
    ///
    /// - Parameters:
    ///   - data: A collection of sections to be rendered.
    open func render<C: Collection>(_ data: C) where C.Element == Section {
        let data = Array(data)

        guard let target = target else {
            adapter.data = data
            return
        }

        updater.performUpdates(target: target, adapter: adapter, data: data)
    }

    /// Render given collection of sections skipping nil, immediately.
    ///
    /// - Parameters:
    ///   - data: A collection of sections to be rendered that can be contains nil.
    open func render<C: Collection>(_ data: C) where C.Element == Section? {
        render(data.compactMap { $0 })
    }

    /// Render given collection sections, immediately.
    ///
    /// - Parameters:
    ///   - data: A variadic number of sections to be rendered.
    open func render(_ data: Section...) {
        render(data)
    }

    /// Render given variadic number of sections skipping nil, immediately.
    ///
    /// - Parameters:
    ///   - data: A variadic number of sections to be rendered that can be contains nil.
    open func render(_ data: Section?...) {
        render(data.compactMap { $0 })
    }

    /// Render given variadic number of sections with function builder syntax, immediately.
    ///
    /// - Parameters:
    ///   - sections: A closure that constructs sections.
    open func render<S: SectionsBuildable>(@SectionsBuilder sections: () -> S) {
        render(sections().buildSections())
    }

    /// Render a single section contains given cells with function builder syntax, immediately.
    ///
    /// - Parameters:
    ///   - cells: A closure that constructs cells.
    open func render<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        render {
            Section(id: UniqueIdentifier(), cells: cells)
        }
    }
}

private struct UniqueIdentifier: Hashable {}
