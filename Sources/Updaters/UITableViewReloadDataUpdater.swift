import UIKit

/// An updater for managing to perform reload data to render data to the `UITableView`.
open class UITableViewReloadDataUpdater<Adapter: UITableViewAdapter>: Updater {
    /// Create a new updater.
    public init() {}

    /// Set the `delegate` and `dataSource` of given table view, then reload data.
    ///
    /// - Parameters:
    ///   - target: A target to be prepared.
    ///   - adapter: An adapter to be set to `delegate` and `dataSource`.
    open func prepare(target: UITableView, adapter: Adapter) {
        target.delegate = adapter
        target.dataSource = adapter
        target.reloadData()
    }

    /// Perform reload data to render given data to the target.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    open func performUpdates(target: UITableView, adapter: Adapter, data: [Section]) {
        adapter.data = data
        target.reloadData()
    }
}
