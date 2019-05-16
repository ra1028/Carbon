import UIKit

/// An adapter for `UITableView`.
/// It can be inherited to implement customized behavior or give some unimplemented
/// methods of delegate or dataSource.
/// Classes of cell, header and footer to be rendered can be customized by `UITableViewRenderConfig`.
///
/// Attention : In UIKit, if inheriting the @objc class which using generics, the delegate and dataSource
///             are don't work properly, so this class doesn't use generics, and also the class inherited
///             this class shouldn't use generics.
open class UITableViewAdapter: NSObject, Adapter {
    /// The data to be rendered in the list UI.
    public var data: [Section]

    /// A closure that to handle selection events of cell.
    open var didSelect: ((SelectionContext) -> Void)?

    /// Create an adapter with initial data and rendering config.
    ///
    /// - Parameters:
    ///   - data: An initial data to be rendered.
    public init(data: [Section] = []) {
        self.data = data
    }

    open func containerCellClass(tableView: UITableView, indexPath: IndexPath, node: CellNode) -> (UITableViewCell & ComponentRenderable).Type {
        return UITableViewComponentCell.self
    }

    open func containerHeaderViewClass(tableView: UITableView, section: Int, node: ViewNode) -> (UITableViewHeaderFooterView & ComponentRenderable).Type {
        return UITableViewComponentHeaderFooterView.self
    }

    open func containerFooterViewClass(tableView: UITableView, section: Int, node: ViewNode) -> (UITableViewHeaderFooterView & ComponentRenderable).Type {
        return UITableViewComponentHeaderFooterView.self
    }

    open func dequeueContainerCell(
        tableView: UITableView,
        indexPath: IndexPath,
        node: CellNode,
        class cellClass: (UITableViewCell & ComponentRenderable).Type
        ) -> UITableViewCell {
        let reuseIdentifier = node.component.reuseIdentifier

        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? UITableViewCell & ComponentRenderable, cell.isMember(of: cellClass) else {
            tableView.register(cellClass.self, forCellReuseIdentifier: reuseIdentifier)
            return self.tableView(tableView, cellForRowAt: indexPath)
        }

        cell.render(component: node.component)
        return cell
    }

    open func dequeueContainerHeaderFooterView(
        tableView: UITableView,
        section: Int,
        node: ViewNode,
        class viewClass: (UITableViewHeaderFooterView & ComponentRenderable).Type
        ) -> UITableViewHeaderFooterView {
        let reuseIdentifier = node.component.reuseIdentifier

        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? UITableViewHeaderFooterView & ComponentRenderable,
            view.isMember(of: viewClass) else {
                tableView.register(viewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
                return dequeueContainerHeaderFooterView(tableView: tableView, section: section, node: node, class: viewClass)
        }

        view.render(component: node.component)
        return view
    }
}

public extension UITableViewAdapter {
    /// Context when cell is selected.
    struct SelectionContext {
        /// A table view of the selected cell.
        public var tableView: UITableView

        /// A node corresponding to the selected cell position.
        public var node: CellNode

        /// The index path of the selected cell.
        public var indexPath: IndexPath
    }
}

extension UITableViewAdapter: UITableViewDataSource {
    /// Return the number of sections.
    open func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    /// Return the number of rows in specified section.
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNodes(in: section).count
    }

    /// Resister and dequeue the cell at specified index path.
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = cellNode(at: indexPath)
        let cellClass = containerCellClass(tableView: tableView, indexPath: indexPath, node: node)
        return dequeueContainerCell(tableView: tableView, indexPath: indexPath, node: node, class: cellClass)
    }
}

extension UITableViewAdapter: UITableViewDelegate {
    /// Resister and dequeue the header in specified section.
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let node = headerNode(in: section) else { return nil }

        let viewClass = containerHeaderViewClass(tableView: tableView, section: section, node: node)
        return dequeueContainerHeaderFooterView(tableView: tableView, section: section, node: node, class: viewClass)
    }

    /// Resister and dequeue the footer in specified section.
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let node = footerNode(in: section) else { return nil }

        let viewClass = containerFooterViewClass(tableView: tableView, section: section, node: node)
        return dequeueContainerHeaderFooterView(tableView: tableView, section: section, node: node, class: viewClass)
    }

    /// Returns the height for row at specified index path.
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow(in: tableView, indexPath: indexPath, defaultHeight: tableView.rowHeight)
    }

    /// Returns the estimated height for row at specified index path.
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow(in: tableView, indexPath: indexPath, defaultHeight: tableView.estimatedRowHeight)
    }

    /// Returns the height for header in specified section.
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader(in: tableView, section: section, defaultHeight: tableView.sectionHeaderHeight, leastHeight: .leastNonzeroMagnitude)
    }

    /// Returns the estimated height for header in specified section.
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader(in: tableView, section: section, defaultHeight: tableView.estimatedSectionHeaderHeight, leastHeight: .leastHeaderFooterEstimatedHeight)
    }

    /// Returns the height for footer in specified section.
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter(in: tableView, section: section, defaultHeight: tableView.sectionFooterHeight, leastHeight: .leastNonzeroMagnitude)
    }

    /// Returns the estimated height for footer in specified section.
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter(in: tableView, section: section, defaultHeight: tableView.estimatedSectionFooterHeight, leastHeight: .leastHeaderFooterEstimatedHeight)
    }

    /// Callback the selected event of cell to the `didSelect` closure.
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let didSelect = didSelect else { return }

        let node = cellNode(at: indexPath)
        let context = SelectionContext(tableView: tableView, node: node, indexPath: indexPath)
        didSelect(context)

        // In rare cases, execution such as presenting view controller may be delayed if set the `UITableViewCell.selectionStyle` to `.none`.
        // This is workaround for it.
        // http://openradar.appspot.com/19563577
        // https://stackoverflow.com/questions/21075540/presentviewcontrolleranimatedyes-view-will-not-appear-until-user-taps-again
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

    /// The event that the cell will display in the visible rect.
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ComponentRenderable)?.contentWillDisplay()
    }

    /// The event that the cell did left from the visible rect.
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ComponentRenderable)?.contentDidEndDisplay()
    }

    /// The event that the header will display in the visible rect.
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? ComponentRenderable)?.contentWillDisplay()
    }

    /// The event that the header did left from the visible rect.
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        (view as? ComponentRenderable)?.contentDidEndDisplay()
    }

    /// The event that the footer will display in the visible rect.
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? ComponentRenderable)?.contentWillDisplay()
    }

    /// The event that the footer did left from the visible rect.
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        (view as? ComponentRenderable)?.contentDidEndDisplay()
    }
}

private extension UITableViewAdapter {
    func heightForRow(in tableView: UITableView, indexPath: IndexPath, defaultHeight: CGFloat) -> CGFloat {
        let node = cellNode(at: indexPath)
        return node.component.referenceSize(in: tableView.bounds)?.height ?? defaultHeight
    }

    func heightForHeader(in tableView: UITableView, section: Int, defaultHeight: CGFloat, leastHeight: CGFloat) -> CGFloat {
        guard let node = headerNode(in: section) else {
            let hasHeaderTitle = responds(to: #selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:)))
            return hasHeaderTitle ? defaultHeight : leastHeight
        }

        return node.component.referenceSize(in: tableView.bounds)?.height ?? defaultHeight
    }

    func heightForFooter(in tableView: UITableView, section: Int, defaultHeight: CGFloat, leastHeight: CGFloat) -> CGFloat {
        guard let node = footerNode(in: section) else {
            let hasFooterTitle = responds(to: #selector(UITableViewDataSource.tableView(_:titleForFooterInSection:)))
            return hasFooterTitle ? defaultHeight : leastHeight
        }

        return node.component.referenceSize(in: tableView.bounds)?.height ?? defaultHeight
    }
}

private extension CGFloat {
    /// - Note: If use small `CGFloat` value such as `CGFloat.leastNonzeroMagnitude` to estimated height,
    ///         it cause a crash (section header height must not be negative) on iOS10 or lower.
    ///         Then use `1` to estimated height, the header height is fallback to default.
    ///         `1 + .leastNonzeroMagnitude` is same as `1`.
    static let leastHeaderFooterEstimatedHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return .leastNonzeroMagnitude
        }
        else {
            return 1.001
        }
    }()
}
