import UIKit

/// An adapter for `UICollectionView`.
/// It can be inherited to implement customized behavior or give some unimplemented
/// methods of delegate or dataSource.
/// Classes of cell, header and footer to be rendered can be customized by `UICollectionViewRenderConfig`.
///
/// Attention : In UIKit, if inheriting the @objc class which using generics, the delegate and dataSource
///             are don't work properly, so this class doesn't use generics, and also the class inherited
///             this class shouldn't use generics.
open class UICollectionViewAdapter: NSObject, Adapter {
    /// The data to be rendered in the list UI.
    public var data: [Section]

    /// A configuration that determines the classes of the elements to render.
    public let config: Config

    /// A closure that to handle selection events of cell.
    open var didSelect: ((SelectionContext) -> Void)?

    private var registeredCellReuseIdentifiers = Set<String>()
    private var registeredViewReuseIdentifiersForKind = [String: Set<String>]()

    /// Create an adapter with initial data and rendering config.
    ///
    /// - Parameters:
    ///   - data: An initial data to be rendered.
    ///   - config: A configuration that determines the classes of the elements to render.
    public init(data: [Section] = [], config: Config = .default) {
        self.data = data
        self.config = config
    }
}

public extension UICollectionViewAdapter {
    /// The configuration for the classes of elements in `UICollectionView`.
    struct Config {
        /// The default configuration.
        public static var `default` = Config()

        /// The class of the cell.
        public var cellClass: UICollectionViewComponentCell.Type

        /// The class of the header view.
        public var headerViewClass: UICollectionComponentReusableView.Type

        /// The class of the footer view.
        public var footerViewClass: UICollectionComponentReusableView.Type

        /// Create a render configuration with the classes of elements.
        ///
        /// - Parameters:
        ///   - cellClass: The class of cell.
        ///   - headerViewClass: The class of header view.
        ///   - footerViewClass: The class of footer view.
        public init(
            cellClass: UICollectionViewComponentCell.Type = UICollectionViewComponentCell.self,
            headerViewClass: UICollectionComponentReusableView.Type = UICollectionComponentReusableView.self,
            footerViewClass: UICollectionComponentReusableView.Type = UICollectionComponentReusableView.self
            ) {
            self.cellClass = cellClass
            self.headerViewClass = headerViewClass
            self.footerViewClass = footerViewClass
        }
    }
}

public extension UICollectionViewAdapter {
    /// Context when cell is selected.
    struct SelectionContext {
        /// A collection view of the selected cell.
        public var collectionView: UICollectionView

        /// A node corresponding to the selected cell position.
        public var node: CellNode

        /// The index path of the selected cell.
        public var indexPath: IndexPath
    }
}

extension UICollectionViewAdapter: UICollectionViewDataSource {
    /// Return the number of sections.
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    /// Return the number of items in specified section.
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNodes(in: section).count
    }

    /// Resister and dequeue the cell at specified index path.
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let node = cellNode(at: indexPath)
        let reuseIdentifier = node.component.reuseIdentifier
        let cellClass = config.cellClass

        if !registeredCellReuseIdentifiers.contains(reuseIdentifier) {
            collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
            registeredCellReuseIdentifiers.insert(reuseIdentifier)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionViewComponentCell

        cell.render(component: node.component)
        return cell
    }

    /// Resister and dequeue the header or footer in specified section.
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let node: ViewNode
        let viewClass: UICollectionComponentReusableView.Type

        if kind == UICollectionView.elementKindSectionHeader, let headerNode = headerNode(in: indexPath.section) {
            node = headerNode
            viewClass = config.headerViewClass
        }
        else if kind == UICollectionView.elementKindSectionFooter, let footerNode = footerNode(in: indexPath.section) {
            node = footerNode
            viewClass = config.footerViewClass
        }
        else {
            assertionFailure("Header or footer are only supported.")
            return UICollectionReusableView()
        }

        return supplementaryView(
            in: collectionView,
            node: node,
            kind: kind,
            indexPath: indexPath,
            viewClass: viewClass
        )
    }
}

extension UICollectionViewAdapter: UICollectionViewDelegate {
    /// Callback the selected event of cell to the `didSelect` closure.
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let didSelect = didSelect else { return }

        let node = cellNode(at: indexPath)
        let context = SelectionContext(collectionView: collectionView, node: node, indexPath: indexPath)
        didSelect(context)
    }

    /// The event that the cell will display in the visible rect.
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ComponentContainer)?.contentWillDisplay()
    }

    /// The event that the cell did left from the visible rect.
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ComponentContainer)?.contentDidEndDisplay()
    }

    /// The event that the header or footer will display in the visible rect.
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        (view as? ComponentContainer)?.contentWillDisplay()
    }

    /// The event that the header or footer did left from the visible rect.
    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        (view as? ComponentContainer)?.contentDidEndDisplay()
    }
}

private extension UICollectionViewAdapter {
    func supplementaryView<T: UICollectionComponentReusableView>(
        in collectionView: UICollectionView,
        node: ViewNode,
        kind: String,
        indexPath: IndexPath,
        viewClass: T.Type
        ) -> UICollectionComponentReusableView {
        let component = node.component
        let reuseIdentifier = component.reuseIdentifier

        let contains = registeredViewReuseIdentifiersForKind[kind]?.contains(reuseIdentifier) ?? false
        if !contains {
            collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
            registeredViewReuseIdentifiersForKind[kind, default: []].insert(reuseIdentifier)
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionComponentReusableView

        view.render(component: component)
        return view
    }
}
