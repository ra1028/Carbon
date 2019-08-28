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
    let content: UIView

    private(set) weak var contentCapturedOnWillDisplay: UIView?
    private(set) weak var contentCapturedOnDidEndDisplay: UIView?
    private(set) weak var contentCapturedOnRender: UIView?

    init(
        referenceSize: CGSize? = nil,
        shouldContentUpdate: Bool = false,
        shouldRender: Bool = false,
        content: UIView = UIView()
        ) {
        self.referenceSize = referenceSize
        self.shouldContentUpdate = shouldContentUpdate
        self.shouldRender = shouldRender
        self.content = content
    }

    func renderContent() -> UIView {
        return content
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

    func performUpdates(target: MockTarget, adapter: MockAdapter, data: [Section]) {
        adapter.data = data
        targetCapturedOnUpdates = target
        adapterCapturedOnUpdates = adapter
    }
}

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
    var customRectForSection: (Int) -> CGRect = { _ in CGRect(x: 0, y: 0, width: 500, height: 500) }

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
        return customRectForSection(section)
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

final class MockComponentContainer: ComponentRenderable {
    let componentContainerView: UIView

    init(componentContainerView: UIView = UIView()) {
        self.componentContainerView = componentContainerView
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

final class MockCustomTableViewCell1: UITableViewCell, ComponentRenderable {}
final class MockCustomTableViewCell2: UITableViewCell, ComponentRenderable {}
final class MockCustomXibTableViewCell: UITableViewCell, ComponentRenderable {}
final class MockCustomTableViewHeaderFooterView1: UITableViewHeaderFooterView, ComponentRenderable {}
final class MockCustomTableViewHeaderFooterView2: UITableViewHeaderFooterView, ComponentRenderable {}
final class MockCustomXibTableViewHeaderFooterView: UITableViewHeaderFooterView, ComponentRenderable {}

final class MockCustomTableViewAdapter: UITableViewAdapter {
    var cellRegistration = CellRegistration(class: MockCustomTableViewCell1.self)
    var headerRegistration = ViewRegistration(class: MockCustomTableViewHeaderFooterView1.self)
    var footerRegistration = ViewRegistration(class: MockCustomTableViewHeaderFooterView1.self)

    override func cellRegistration(tableView: UITableView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        return cellRegistration
    }

    override func headerViewRegistration(tableView: UITableView, section: Int, node: ViewNode) -> ViewRegistration {
        return headerRegistration
    }

    override func footerViewRegistration(tableView: UITableView, section: Int, node: ViewNode) -> ViewRegistration {
        return footerRegistration
    }
}

final class MockCustomCollectionViewCell1: UICollectionViewCell, ComponentRenderable {}
final class MockCustomCollectionViewCell2: UICollectionViewCell, ComponentRenderable {}
final class MockCustomXibCollectionViewCell: UICollectionViewCell, ComponentRenderable {}
final class MockCustomCollectionViewReusableView1: UICollectionReusableView, ComponentRenderable {}
final class MockCustomCollectionViewReusableView2: UICollectionReusableView, ComponentRenderable {}
final class MockCustomXibCollectionViewReusableView: UICollectionReusableView, ComponentRenderable {}

final class MockCustomCollectionViewAdapter: UICollectionViewAdapter {
    var cellRegistration = CellRegistration(class: MockCustomCollectionViewCell1.self)
    var supplementaryViewRegistrations: [String: ViewRegistration] = [:]

    override func cellRegistration(collectionView: UICollectionView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        return cellRegistration
    }

    override func supplementaryViewRegistration(forElementKind kind: String, collectionView: UICollectionView, indexPath: IndexPath, node: ViewNode) -> ViewRegistration {
        return supplementaryViewRegistrations[kind] ?? ViewRegistration(class: MockCustomCollectionViewReusableView1.self)
    }
}

/// Extract `renderedContent` from specified container.
func renderedContent<T>(of container: Any, as type: T.Type) -> T? {
    guard
        let container = container as? ComponentRenderable,
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

extension UINib {
    convenience init(for class: AnyClass) {
        self.init(nibName: String(describing: `class`), bundle: Bundle(for: `class`))
    }
}
