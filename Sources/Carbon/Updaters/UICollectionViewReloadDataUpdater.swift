import UIKit

/// An updater for managing to perform reload data to render data to the `UICollectionView`.
open class UICollectionViewReloadDataUpdater<Adapter: Carbon.Adapter & UICollectionViewDelegate & UICollectionViewDataSource>: Updater {
    /// Create a new updater.
    public init() {}

    /// Set the `delegate` and `dataSource` of given collection view, then reload data and invalidate layout.
    ///
    /// - Parameters:
    ///   - target: A target to be prepared.
    ///   - adapter: An adapter to be set to `delegate` and `dataSource`.
    open func prepare(target: UICollectionView, adapter: Adapter) {
        target.delegate = adapter
        target.dataSource = adapter
        target.reloadData()
        target.collectionViewLayout.invalidateLayout()
    }

    /// Perform reload data to render given data to the target.
    /// The completion is called after reload data, not after completion of the layout.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    ///   - completion: A closure that to callback end of update.
    open func performUpdates(target: UICollectionView, adapter: Adapter, data: [Section], completion: (() -> Void)?) {
        adapter.data = data
        target.reloadData()
        completion?()
    }
}
