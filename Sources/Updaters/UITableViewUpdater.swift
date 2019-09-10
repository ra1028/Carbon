import UIKit

/// An updater for managing diffing updates to render data to the `UITableView`.
open class UITableViewUpdater<Adapter: UITableViewAdapter>: Updater {
    /// An animation for section deletions. Default is fade.
    open var deleteSectionsAnimation = UITableView.RowAnimation.fade

    /// An animation for section insertions. Default is fade.
    open var insertSectionsAnimation = UITableView.RowAnimation.fade

    /// An animation for section reloads. Default is fade.
    open var reloadSectionsAnimation = UITableView.RowAnimation.fade

    /// An animation for row deletions. Default is fade.
    open var deleteRowsAnimation = UITableView.RowAnimation.fade

    /// An animation for row insertions. Default is fade.
    open var insertRowsAnimation = UITableView.RowAnimation.fade

    /// An animation for row reloads. Default is fade.
    open var reloadRowsAnimation = UITableView.RowAnimation.fade

    /// A Bool value indicating whether that enable diffing animation. Default is true.
    open var isAnimationEnabled = true

    /// A Bool value indicating whether that enable diffing animation while target is
    /// scrolling. Default is false.
    open var isAnimationEnabledWhileScrolling = false

    /// A Bool value indicating whether that to always render visible components
    /// after diffing updated. Default is true.
    open var alwaysRenderVisibleComponents = true

    /// A Bool value indicating whether that to reset content offset after
    /// updated if not scrolling. Default is true.
    open var keepsContentOffset = true

    /// Max number of changes that can be animated for diffing updates. Default is 300.
    open var animatableChangeCount = 300

    /// A completion handler to be called after each updates.
    open var completion: (() -> Void)?

    /// Create a new updater.
    public init() {}

    /// Set given animation to all kind of diffing updates.
    ///
    /// - Parameter
    ///   - animation: An animation for all kind of diffing updates.
    open func set(allAnimation animation: UITableView.RowAnimation) {
        deleteSectionsAnimation = animation
        insertSectionsAnimation = animation
        reloadSectionsAnimation = animation
        deleteRowsAnimation = animation
        insertRowsAnimation = animation
        reloadRowsAnimation = animation
    }

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

    /// Perform updates to render given data to the target.
    /// The completion is expected to be called after all updates
    /// and the its animations.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    open func performUpdates(target: UITableView, adapter: Adapter, data: [Section]) {
        guard case .some = target.window else {
            adapter.data = data
            target.reloadData()
            completion?()
            return
        }

        let stagedChangeset = StagedDataChangeset(source: adapter.data, target: data)

        guard !stagedChangeset.isEmpty else {
            adapter.data = data
            renderVisibleComponentsIfNeeded(in: target, adapter: adapter)
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

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        performDifferentialUpdates(target: target, adapter: adapter, stagedChangeset: stagedChangeset)

        CATransaction.commit()
    }

    /// Perform diffing updates to render given data to the target.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - stagedChangeset: A staged set of changes of current data and next data.
    open func performDifferentialUpdates(target: UITableView, adapter: Adapter, stagedChangeset: StagedDataChangeset) {
        let contentOffsetBeforeUpdates = target.contentOffset

        func performBatchUpdates() {
            for changeset in stagedChangeset {
                target._performBatchUpdates {
                    adapter.data = changeset.data

                    if !changeset.sectionDeleted.isEmpty {
                        target.deleteSections(IndexSet(changeset.sectionDeleted), with: deleteSectionsAnimation)
                    }

                    if !changeset.sectionInserted.isEmpty {
                        target.insertSections(IndexSet(changeset.sectionInserted), with: insertSectionsAnimation)
                    }

                    if !changeset.sectionUpdated.isEmpty {
                        target.reloadSections(IndexSet(changeset.sectionUpdated), with: reloadSectionsAnimation)
                    }

                    for (sourceIndex, targetIndex) in changeset.sectionMoved {
                        target.moveSection(sourceIndex, toSection: targetIndex)
                    }

                    if !changeset.elementDeleted.isEmpty {
                        target.deleteRows(at: changeset.elementDeleted.map { IndexPath(row: $0.element, section: $0.section) }, with: deleteRowsAnimation)
                    }

                    if !changeset.elementInserted.isEmpty {
                        target.insertRows(at: changeset.elementInserted.map { IndexPath(row: $0.element, section: $0.section) }, with: insertRowsAnimation)
                    }

                    if !changeset.elementUpdated.isEmpty {
                        target.reloadRows(at: changeset.elementUpdated.map { IndexPath(row: $0.element, section: $0.section) }, with: reloadRowsAnimation)
                    }

                    for (sourcePath, targetPath) in changeset.elementMoved {
                        target.moveRow(at: IndexPath(row: sourcePath.element, section: sourcePath.section), to: IndexPath(row: targetPath.element, section: targetPath.section))
                    }
                }
            }
        }

        if isAnimationEnabled && (isAnimationEnabledWhileScrolling || !target._isScrolling) {
            performBatchUpdates()
        }
        else {
            UIView.performWithoutAnimation(performBatchUpdates)
        }

        if keepsContentOffset {
            target._setAdjustedContentOffsetIfNeeded(contentOffsetBeforeUpdates)
        }

        renderVisibleComponentsIfNeeded(in: target, adapter: adapter)
    }

    /// Renders components displayed in visible area again.
    ///
    /// - Parameters:
    ///   - target: A target instance to render components.
    ///   - adapter: An adapter holding currently rendered data.
    open func renderVisibleComponents(in target: UITableView, adapter: Adapter) {
        UIView.performWithoutAnimation {
            target._performBatchUpdates {
                let sections = 0..<target.numberOfSections
                let visibleRect = target.bounds

                for section in sections {
                    guard target.rect(forSection: section).intersects(visibleRect) else {
                        continue
                    }

                    if let headerNode = adapter.headerNode(in: section) {
                        let view = target.headerView(forSection: section) as? ComponentRenderable
                        view?.render(component: headerNode.component)
                    }

                    if let footerNode = adapter.footerNode(in: section) {
                        let view = target.footerView(forSection: section) as? ComponentRenderable
                        view?.render(component: footerNode.component)
                    }
                }

                for indexPath in target.indexPathsForVisibleRows ?? [] {
                    let cellNode = adapter.cellNode(at: indexPath)
                    let cell = target.cellForRow(at: indexPath) as? ComponentRenderable
                    cell?.render(component: cellNode.component)
                }
            }
        }
    }
}

private extension UITableViewUpdater {
    func renderVisibleComponentsIfNeeded(in target: UITableView, adapter: Adapter) {
        if alwaysRenderVisibleComponents {
            renderVisibleComponents(in: target, adapter: adapter)
        }
    }
}

private extension UITableView {
    func _performBatchUpdates(_ updates: () -> Void) {
        if #available(iOS 11.0, tvOS 11.0, *) {
            performBatchUpdates(updates)
        }
        else {
            beginUpdates()
            updates()
            endUpdates()
        }
    }
}
