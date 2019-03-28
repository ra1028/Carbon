import XCTest
import UIKit
@testable import Carbon

/// Identifier for tests.
enum TestID {
    case a, b, c, d
}

/// Namespace A.
enum A {
    final class Content: UIView {}

    struct Component: IdentifiableComponent, Hashable {
        var value = 0

        func renderContent() -> Content {
            return Content()
        }

        func render(in content: Content) {}

        func referenceSize(in bounds: CGRect) -> CGSize? {
            return nil
        }

        func shouldRender(next: A.Component, in content: A.Content) -> Bool {
            return false
        }
    }
}

/// Namespace B.
enum B {
    final class Content: UIView {}

    struct Component: IdentifiableComponent, Hashable {
        var value = 0

        func renderContent() -> Content {
            return Content()
        }

        func render(in content: Content) {}

        func referenceSize(in bounds: CGRect) -> CGSize? {
            return nil
        }

        func shouldRender(next: B.Component, in content: B.Content) -> Bool {
            return false
        }
    }
}

class MockComponent: Component, Equatable {
    let referenceSize: CGSize?
    let shouldContentUpdate: Bool
    let shouldRender: Bool

    private(set) weak var contentCapturedOnWillDisplay: UIView?
    private(set) weak var contentCapturedOnDidEndDisplay: UIView?
    private(set) weak var contentCapturedOnRender: UIView?

    init(
        referenceSize: CGSize? = nil,
        shouldContentUpdate: Bool = false,
        shouldRender: Bool = false
        ) {
        self.referenceSize = referenceSize
        self.shouldContentUpdate = shouldContentUpdate
        self.shouldRender = shouldRender
    }

    func renderContent() -> UIView {
        return UIView()
    }

    func render(in content: UIView) {
        contentCapturedOnRender = content
    }

    func shouldContentUpdate(with next: MockComponent) -> Bool {
        return shouldContentUpdate
    }

    func shouldRender(next: MockComponent, in content: UIView) -> Bool {
        return shouldRender
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return referenceSize
    }

    func contentWillDisplay(_ content: UIView) {
        contentCapturedOnWillDisplay = content
    }

    func contentDidEndDisplay(_ content: UIView) {
        contentCapturedOnDidEndDisplay = content
    }

    static func == (lhs: MockComponent, rhs: MockComponent) -> Bool {
        return lhs === rhs
    }
}

final class MockIdentifiableComponent<ID: Hashable>: MockComponent, IdentifiableComponent {
    let id: ID

    init(id: ID) {
        self.id = id
    }
}

final class MockTarget: Equatable {
    static func == (lhs: MockTarget, rhs: MockTarget) -> Bool {
        return lhs === rhs
    }
}

final class MockAdapter: Adapter, Equatable {
    var data: [Section] = []

    static func == (lhs: MockAdapter, rhs: MockAdapter) -> Bool {
        return lhs === rhs
    }
}

final class MockUpdater: Updater {
    typealias Target = MockTarget
    typealias Adapter = MockAdapter

    weak var targetCapturedOnPrepare: Target?
    weak var targetCapturedOnUpdates: Target?
    weak var adapterCapturedOnPrepare: Adapter?
    weak var adapterCapturedOnUpdates: Adapter?

    func prepare(target: MockTarget, adapter: MockAdapter) {
        targetCapturedOnPrepare = target
        adapterCapturedOnPrepare = adapter
    }

    func performUpdates(target: MockTarget, adapter: MockAdapter, data: [Section], completion: (() -> Void)?) {
        adapter.data = data
        targetCapturedOnUpdates = target
        adapterCapturedOnUpdates = adapter
        completion?()
    }
}

final class MockTableViewCell: UITableViewComponentCell {}

final class MockTableViewHeaderFooterView: UITableViewComponentHeaderFooterView {}

final class MockCollectionViewCell: UICollectionViewComponentCell {}

final class MockCollectionReusableView: UICollectionComponentReusableView {}

final class MockTableView: UITableView {
    var isReloadDataCalled = false

    var deletedSections: IndexSet = []
    var insertedSections: IndexSet = []
    var reloadedSections: IndexSet = []
    var movedSections: [(source: Int, target: Int)] = []

    var deletedRows: [IndexPath] = []
    var insertedRows: [IndexPath] = []
    var reloadedRows: [IndexPath] = []
    var movedRows: [(source: IndexPath, target: IndexPath)] = []

    var hasChanges: Bool {
        return !deletedSections.isEmpty
            || !insertedSections.isEmpty
            || !reloadedSections.isEmpty
            || !movedSections.isEmpty
            || !deletedRows.isEmpty
            || !insertedRows.isEmpty
            || !reloadedRows.isEmpty
            || !movedRows.isEmpty
    }

    var customNumberOfSections: Int?
    var customIndexPathsForVisibleRows: [IndexPath]?
    var customCellForRowAt: ((IndexPath) -> UITableViewCell?)?
    var customHeaderViewForSection: ((Int) -> UITableViewHeaderFooterView)?
    var customFooterViewForSection: ((Int) -> UITableViewHeaderFooterView)?

    override var numberOfSections: Int {
        return customNumberOfSections ?? super.numberOfSections
    }

    override var indexPathsForVisibleRows: [IndexPath]? {
        return customIndexPathsForVisibleRows ?? super.indexPathsForVisibleRows
    }

    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return customCellForRowAt?(indexPath) ?? super.cellForRow(at: indexPath)
    }

    override func headerView(forSection section: Int) -> UITableViewHeaderFooterView? {
        return customHeaderViewForSection?(section) ?? super.headerView(forSection: section)
    }

    override func footerView(forSection section: Int) -> UITableViewHeaderFooterView? {
        return customFooterViewForSection?(section) ?? super.footerView(forSection: section)
    }

    override func rect(forSection section: Int) -> CGRect {
        return CGRect(x: 0, y: 0, width: 500, height: 500)
    }

    override func layoutSubviews() {
        // Prevent to called `reloadData` implicitly by system.
    }

    override func reloadData() {
        isReloadDataCalled = true
    }

    override func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        deletedSections.formUnion(sections)
    }

    override func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        insertedSections.formUnion(sections)
    }

    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        reloadedSections.formUnion(sections)
    }

    override func moveSection(_ section: Int, toSection newSection: Int) {
        movedSections.append((source: section, target: newSection))
    }

    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        deletedRows += indexPaths
    }

    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        insertedRows += indexPaths
    }

    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        reloadedRows += indexPaths
    }

    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        movedRows.append((source: indexPath, target: newIndexPath))
    }
}

final class MockTableViewAdapter: UITableViewAdapter {}

final class MockTableViewUpdater: UITableViewUpdater<MockTableViewAdapter> {}

final class MockTableViewReloadDataUpdater: UITableViewReloadDataUpdater<MockTableViewAdapter> {}

final class MockCollectionView: UICollectionView {
    var isReloadDataCalled = false

    var deletedSections: IndexSet = []
    var insertedSections: IndexSet = []
    var reloadedSections: IndexSet = []
    var movedSections: [(source: Int, target: Int)] = []

    var deletedItems: [IndexPath] = []
    var insertedItems: [IndexPath] = []
    var reloadedItems: [IndexPath] = []
    var movedItems: [(source: IndexPath, target: IndexPath)] = []

    var hasChanges: Bool {
        return !deletedSections.isEmpty
            || !insertedSections.isEmpty
            || !reloadedSections.isEmpty
            || !movedSections.isEmpty
            || !deletedItems.isEmpty
            || !insertedItems.isEmpty
            || !reloadedItems.isEmpty
            || !movedItems.isEmpty
    }

    var customIndexPathsForVisibleSupplementaryElementsOfKind: ((String) -> [IndexPath])?
    var customIndexPathsForVisibleItems: [IndexPath]?
    var customSupplementaryViewForElementKindAt: ((String, IndexPath) -> UICollectionReusableView?)?
    var customCellForItemAt: ((IndexPath) -> UICollectionViewCell?)?

    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func indexPathsForVisibleSupplementaryElements(ofKind elementKind: String) -> [IndexPath] {
        return customIndexPathsForVisibleSupplementaryElementsOfKind?(elementKind) ?? super.indexPathsForVisibleSupplementaryElements(ofKind: elementKind)
    }

    override var indexPathsForVisibleItems: [IndexPath] {
        return customIndexPathsForVisibleItems ?? super.indexPathsForVisibleItems
    }

    override func supplementaryView(forElementKind elementKind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        return customSupplementaryViewForElementKindAt?(elementKind, indexPath) ?? super.supplementaryView(forElementKind: elementKind, at: indexPath)
    }

    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return customCellForItemAt?(indexPath) ?? super.cellForItem(at: indexPath)
    }

    override func layoutSubviews() {
        // Prevent to called `reloadData` implicitly by system.
    }

    override func reloadData() {
        isReloadDataCalled = true
    }

    override func deleteSections(_ sections: IndexSet) {
        deletedSections.formUnion(sections)
    }

    override func insertSections(_ sections: IndexSet) {
        insertedSections.formUnion(sections)
    }

    override func reloadSections(_ sections: IndexSet) {
        reloadedSections.formUnion(sections)
    }

    override func moveSection(_ section: Int, toSection newSection: Int) {
        movedSections.append((source: section, target: newSection))
    }

    override func deleteItems(at indexPaths: [IndexPath]) {
        deletedItems += indexPaths
    }

    override func insertItems(at indexPaths: [IndexPath]) {
        insertedItems += indexPaths
    }

    override func reloadItems(at indexPaths: [IndexPath]) {
        reloadedItems += indexPaths
    }

    override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        movedItems.append((source: indexPath, target: newIndexPath))
    }
}

final class MockCollectionViewFlowLayoutAdapter: UICollectionViewFlowLayoutAdapter {}

final class MockCollectionViewUpdater: UICollectionViewUpdater<MockCollectionViewFlowLayoutAdapter> {}

final class MockCollectionViewReloadDataUpdater: UICollectionViewReloadDataUpdater<MockCollectionViewFlowLayoutAdapter> {}

final class MockComponentContainer: ComponentContainer {
    var renderedContent: Any?
    var renderedComponent: AnyComponent?
    let containerView: UIView

    var contentCapturedOnDidRender: Any?
    var componentCapturedOnDidRender: AnyComponent?

    init(containerView: UIView = UIView()) {
        self.containerView = containerView
    }

    func didRenderContent(_ content: Any) {
        contentCapturedOnDidRender = content
    }
    func didRenderComponent(_ component: AnyComponent) {
        componentCapturedOnDidRender = component
    }
}

final class MockTableViewCellContent: UITableViewCellContent {
    var cellCapturedOnPrepareForReuse: UITableViewCell?
    var cellCapturedOnHighlighted: UITableViewCell?
    var cellCapturedOnSelected: UITableViewCell?
    var cellCapturedOnEditing: UITableViewCell?
    var cellCapturedOnDidRender: UITableViewCell?
    var cellCapturedOnDidRenderComponent: UITableViewCell?

    func cellDidPrepareForReuse(_ cell: UITableViewCell) {
        cellCapturedOnPrepareForReuse = cell
    }

    func cellDidSetHighlighted(_ cell: UITableViewCell, isHighlighted: Bool, animated: Bool) {
        cellCapturedOnHighlighted = cell
    }

    func cellDidSetSelected(_ cell: UITableViewCell, isSelected: Bool, animated: Bool) {
        cellCapturedOnSelected = cell
    }

    func cellDidSetEditing(_ cell: UITableViewCell, isEditing: Bool, animated: Bool) {
        cellCapturedOnEditing = cell
    }

    func didRender(in cell: UITableViewCell) {
        cellCapturedOnDidRender = cell
    }

    func didRenderComponent(in cell: UITableViewCell) {
        cellCapturedOnDidRenderComponent = cell
    }
}

final class MockTableViewHeaderFooterViewContent: UITableViewHeaderFooterViewContent {
    var viewCapturedOnPrepareForReuse: UITableViewHeaderFooterView?
    var viewCapturedOnDidRender: UITableViewHeaderFooterView?
    var viewCapturedOnDidRenderComponent: UITableViewHeaderFooterView?

    func viwDidPrepareForReuse(_ view: UITableViewHeaderFooterView) {
        viewCapturedOnPrepareForReuse = view
    }

    func didRender(in view: UITableViewHeaderFooterView) {
        viewCapturedOnDidRender = view
    }

    func didRenderComponent(in view: UITableViewHeaderFooterView) {
        viewCapturedOnDidRenderComponent = view
    }
}

final class MockCollectionViewCellContent: UICollectionViewCellContent {
    var cellCapturedOnPrepareForReuse: UICollectionViewCell?
    var cellCapturedOnHighlighted: UICollectionViewCell?
    var cellCapturedOnSelected: UICollectionViewCell?
    var cellCapturedOnDidRender: UICollectionViewCell?
    var cellCapturedOnDidRenderComponent: UICollectionViewCell?

    func cellDidPrepareForReuse(_ cell: UICollectionViewCell) {
        cellCapturedOnPrepareForReuse = cell
    }

    func cellDidSetHighlighted(_ cell: UICollectionViewCell, isHighlighted: Bool) {
        cellCapturedOnHighlighted = cell
    }

    func cellDidSetSelected(_ cell: UICollectionViewCell, isSelected: Bool) {
        cellCapturedOnSelected = cell
    }

    func didRender(in cell: UICollectionViewCell) {
        cellCapturedOnDidRender = cell
    }

    func didRenderComponent(in cell: UICollectionViewCell) {
        cellCapturedOnDidRenderComponent = cell
    }
}

final class MockCollectionReusableViewContent: UICollectionReusableViewContent {
    var viewCapturedOnPrepareForReuse: UICollectionReusableView?
    var viewCapturedOnDidRender: UICollectionReusableView?
    var viewCapturedOnDidRenderComponent: UICollectionReusableView?

    func viewDidPrepareForReuse(_ view: UICollectionReusableView) {
        viewCapturedOnPrepareForReuse = view
    }

    func didRender(in view: UICollectionReusableView) {
        viewCapturedOnDidRender = view
    }

    func didRenderComponent(in view: UICollectionReusableView) {
        viewCapturedOnDidRenderComponent = view
    }
}

final class MockScrollView: UIScrollView {
    var _isTracking: Bool = false
    override var isTracking: Bool {
        return _isTracking
    }

    var _isDragging: Bool = false
    override var isDragging: Bool {
        return _isDragging
    }

    var _isDecelerating: Bool = false
    override var isDecelerating: Bool {
        return _isDecelerating
    }
}

/// Extract `renderedContent` from specified container.
func renderedContent<T>(of container: Any, as type: T.Type) -> T? {
    guard
        let container = container as? ComponentContainer,
        let content = container.renderedContent as? T else {
            XCTFail()
            return nil
    }

    return content
}

/// The value pair.
struct Pair<T, U> {
    var left: T
    var right: U

    init(_ left: T, _ right: U) {
        self.left = left
        self.right = right
    }
}

extension Pair: Equatable where T: Equatable, U: Equatable {}

/// Protocol for `UIView` utility.
protocol UIViewConvertible: class {
    var uiView: UIView { get }
}

extension UIViewConvertible {
    func addingToWindow() -> Self {
        let window = UIWindow()
        window.layer.speed = 0
        window.addSubview(uiView)
        return self
    }
}

extension UIView: UIViewConvertible {
    var uiView: UIView {
        return self
    }
}

extension XCTestCase {
    func performAsyncTests(
        block: (XCTestExpectation) -> Void,
        testing: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
        ) {
        let expectation = XCTestExpectation(description: "file: \(file), line: \(line)")
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1

        block(expectation)

        wait(for: [expectation], timeout: 3)

        testing()
    }
}
