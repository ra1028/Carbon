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

    /// A closure that to handle selection events of cell.
    open var didSelect: ((SelectionContext) -> Void)?

    /// Create an adapter with initial data and rendering config.
    ///
    /// - Parameters:
    ///   - data: An initial data to be rendered.
    public init(data: [Section] = []) {
        self.data = data
    }

    open func componentCellClass(collectionView: UICollectionView, indexPath: IndexPath, node: CellNode) -> (UICollectionViewCell & ComponentRenderable).Type {
        return UICollectionViewComponentCell.self
    }

    open func componentSupplementaryViewClass(ofKind kind: String, collectionView: UICollectionView, indexPath: IndexPath, node: ViewNode) -> (UICollectionReusableView & ComponentRenderable).Type {
        return UICollectionComponentReusableView.self
    }

    open func supplementaryViewNode(forElementKind kind: String, at indexPath: IndexPath) -> ViewNode? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerNode(in: indexPath.section)

        case UICollectionView.elementKindSectionFooter:
            return footerNode(in: indexPath.section)

        default:
            return nil
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
        let cellClass = componentCellClass(collectionView: collectionView, indexPath: indexPath, node: node)
        let reuseIdentifier = node.component.reuseIdentifier

        if !collectionView.registeredCellReuseIdentifiers.contains(reuseIdentifier) {
            collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
            collectionView.registeredCellReuseIdentifiers.insert(reuseIdentifier)
        }

        func dequeue() -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            guard let componentCell = cell as? UICollectionViewCell & ComponentRenderable, componentCell.isMember(of: cellClass) else {
                collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
                return dequeue()
            }

            componentCell.render(component: node.component)
            return cell
        }

        return dequeue()
    }

    /// Resister and dequeue the header or footer in specified section.
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let node = supplementaryViewNode(forElementKind: kind, at: indexPath) else {
            assertionFailure("Unsupported supplementary element of kind: \(kind). Override `supplementaryViewNode` or `dequeueComponentSupplementaryView` to adopt this kind.")
            return UICollectionReusableView()
        }

        let viewClass = componentSupplementaryViewClass(ofKind: kind, collectionView: collectionView, indexPath: indexPath, node: node)
        return dequeueComponentSupplementaryView(
            ofKind: kind,
            collectionView: collectionView,
            indexPath: indexPath,
            node: node,
            class: viewClass
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
        (cell as? ComponentRenderable)?.contentWillDisplay()
    }

    /// The event that the cell did left from the visible rect.
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? ComponentRenderable)?.contentDidEndDisplay()
    }

    /// The event that the header or footer will display in the visible rect.
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        (view as? ComponentRenderable)?.contentWillDisplay()
    }

    /// The event that the header or footer did left from the visible rect.
    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        (view as? ComponentRenderable)?.contentDidEndDisplay()
    }
}

private extension UICollectionViewAdapter {
    func dequeueComponentSupplementaryView(
        ofKind kind: String,
        collectionView: UICollectionView,
        indexPath: IndexPath,
        node: ViewNode,
        class viewClass: (UICollectionReusableView & ComponentRenderable).Type
        ) -> UICollectionReusableView {
        let reuseIdentifier = node.component.reuseIdentifier

        let contains = collectionView.registeredViewReuseIdentifiersForKind[kind]?.contains(reuseIdentifier) ?? false
        if !contains {
            collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
            collectionView.registeredViewReuseIdentifiersForKind[kind, default: []].insert(reuseIdentifier)
        }

        func dequeue() -> UICollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            guard let componentView = view as? UICollectionReusableView & ComponentRenderable, componentView.isMember(of: viewClass) else {
                collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                return dequeue()
            }

            componentView.render(component: node.component)
            return view
        }

        return dequeue()
    }
}

private let registeredCellReuseIdentifiersAssociation = RuntimeAssociation<Set<String>>()
private let registeredViewReuseIdentifiersForKindAssociation = RuntimeAssociation<[String: Set<String>]>()

private extension UICollectionView {
    var registeredCellReuseIdentifiers: Set<String> {
        get { return registeredCellReuseIdentifiersAssociation.value(for: self, default: []) }
        set { registeredCellReuseIdentifiersAssociation.set(value: newValue, for: self) }
    }

    var registeredViewReuseIdentifiersForKind: [String: Set<String>] {
        get { return registeredViewReuseIdentifiersForKindAssociation.value(for: self, default: [:]) }
        set { registeredViewReuseIdentifiersForKindAssociation.set(value: newValue, for: self) }
    }
}
