import UIKit

/// An updater for managing diffing updates to render data to the `UICollectionView`.
open class UICollectionViewUpdater<Adapter: Carbon.Adapter & UICollectionViewDelegate & UICollectionViewDataSource>: Updater {
    /// A Bool value indicating whether that enable diffing animation. Default is true.
    open var isAnimationEnabled = true

    /// A Bool value indicating whether that enable diffing animation while target is
    /// scrolling. Default is false.
    open var isAnimationEnabledWhileScrolling = true

    /// A Bool value indicating whether that skips reload components. Default is false.
    open var skipReloadComponents = false

    /// A Bool value indicating whether that to always render visible components
    /// after diffing updated. Default is false.
    open var alwaysRenderVisibleComponents = false

    /// A Bool value indicating whether that to reset content offset after
    /// updated if not scrolling. Default is false.
    open var keepsContentOffset = false

    /// Max number of changes that can be animated for diffing updates. Default is 300.
    open var animatableChangeCount = 300

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

    /// Calculates a set of changes to perform diffing updates.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    ///   - completion: A closure that to callback end of update and animations.
    open func performUpdates(target: UICollectionView, adapter: Adapter, data: [Section], completion: (() -> Void)?) {
        guard case .some = target.window else {
            adapter.data = data
            target.reloadData()
            completion?()
            return
        }

        let stagedChangeset = StagedDataChangeset(source: adapter.data, target: data)
        performDifferentialUpdates(target: target, adapter: adapter, data: data, stagedChangeset: stagedChangeset, completion: completion)
    }

    /// Perform diffing updates to render given data to the target.
    /// The completion is called after all updates and the its animations.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    ///   - stagedChangeset: A staged set of changes of current data and next data..
    ///   - completion: A closure that to callback end of update and animations.
    open func performDifferentialUpdates(target: UICollectionView, adapter: Adapter, data: [Section], stagedChangeset: StagedDataChangeset, completion: (() -> Void)?) {
        func renderVisibleComponentsIfNeeded() {
            if alwaysRenderVisibleComponents {
                renderVisibleComponents(in: target, adapter: adapter)
            }
        }

        guard !stagedChangeset.isEmpty else {
            adapter.data = data
            renderVisibleComponentsIfNeeded()
            completion?()
            return
        }

        let totalChangeCount = stagedChangeset.reduce(0) { total, changeset in
            total + changeset.changeCount
        }

        guard animatableChangeCount >= totalChangeCount else {
            adapter.data = data
            target.reloadData()
            completion?()
            return
        }

        func performAnimatedUpdates() {
            let contentOffsetBeforeUpdates = target.contentOffset

            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)

            for changeset in stagedChangeset {
                target.performBatchUpdates({
                    adapter.data = changeset.data

                    if !changeset.sectionDeleted.isEmpty {
                        target.deleteSections(IndexSet(changeset.sectionDeleted))
                    }

                    if !changeset.sectionInserted.isEmpty {
                        target.insertSections(IndexSet(changeset.sectionInserted))
                    }

                    if !changeset.sectionUpdated.isEmpty {
                        target.reloadSections(IndexSet(changeset.sectionUpdated))
                    }

                    for (sourceIndex, targetIndex) in changeset.sectionMoved {
                        target.moveSection(sourceIndex, toSection: targetIndex)
                    }

                    if !changeset.elementDeleted.isEmpty {
                        target.deleteItems(at: changeset.elementDeleted.map { IndexPath(item: $0.element, section: $0.section) })
                    }

                    if !changeset.elementInserted.isEmpty {
                        target.insertItems(at: changeset.elementInserted.map { IndexPath(item: $0.element, section: $0.section) })
                    }

                    if !skipReloadComponents && !changeset.elementUpdated.isEmpty {
                        target.reloadItems(at: changeset.elementUpdated.map { IndexPath(item: $0.element, section: $0.section) })
                    }

                    for (sourcePath, targetPath) in changeset.elementMoved {
                        target.moveItem(at: IndexPath(item: sourcePath.element, section: sourcePath.section), to: IndexPath(item: targetPath.element, section: targetPath.section))
                    }
                })
            }

            renderVisibleComponentsIfNeeded()

            CATransaction.commit()

            if keepsContentOffset && target._isContetRectContainsBounds && !target._isScrolling {
                target.contentOffset = CGPoint(
                    x: min(target._maxContentOffsetX, contentOffsetBeforeUpdates.x),
                    y: min(target._maxContentOffsetY, contentOffsetBeforeUpdates.y)
                )
            }
        }

        if isAnimationEnabled && (!target._isScrolling || isAnimationEnabledWhileScrolling) {
            performAnimatedUpdates()
        }
        else {
            UIView.performWithoutAnimation(performAnimatedUpdates)
        }
    }

    /// Renders components displayed in visible area again.
    ///
    /// - Parameters:
    ///   - target: A target instance to render components.
    ///   - adapter: An adapter holding currently rendered data.
    open func renderVisibleComponents(in target: UICollectionView, adapter: Adapter) {
        let headerElementKind = UICollectionView.elementKindSectionHeader
        let footerElementKind = UICollectionView.elementKindSectionFooter

        for indexPath in target.indexPathsForVisibleSupplementaryElements(ofKind: headerElementKind) {
            guard let headerNode = adapter.headerNode(in: indexPath.section) else {
                continue
            }

            let view = target.supplementaryView(forElementKind: headerElementKind, at: indexPath) as? ComponentContainer
            view?.render(component: headerNode.component)
        }

        for indexPath in target.indexPathsForVisibleSupplementaryElements(ofKind: footerElementKind) {
            guard let footerNode = adapter.headerNode(in: indexPath.section) else {
                continue
            }

            let view = target.supplementaryView(forElementKind: footerElementKind, at: indexPath) as? ComponentContainer
            view?.render(component: footerNode.component)
        }

        for indexPath in target.indexPathsForVisibleItems {
            let cellNode = adapter.cellNode(at: indexPath)
            let cell = target.cellForItem(at: indexPath) as? ComponentContainer
            cell?.render(component: cellNode.component)
        }
    }
}
