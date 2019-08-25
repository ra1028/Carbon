import XCTest
import DifferenceKit
@testable import Carbon

final class UITableViewUpdaterTests: XCTestCase {
    func testSetAllAnimation() {
        let updater = MockTableViewUpdater()
        updater.set(allAnimation: .right)

        XCTAssertEqual(updater.deleteSectionsAnimation, .right)
        XCTAssertEqual(updater.insertSectionsAnimation, .right)
        XCTAssertEqual(updater.reloadSectionsAnimation, .right)
        XCTAssertEqual(updater.deleteRowsAnimation, .right)
        XCTAssertEqual(updater.insertRowsAnimation, .right)
        XCTAssertEqual(updater.reloadRowsAnimation, .right)
    }

    func testPrepare() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView()
        updater.prepare(target: tableView, adapter: adapter)

        XCTAssertTrue(tableView.isReloadDataCalled)
        XCTAssertEqual(tableView.delegate as? MockTableViewAdapter, adapter)
        XCTAssertEqual(tableView.dataSource as? MockTableViewAdapter, adapter)
    }

    func testReloadDataFallbackIfNotInViewHierarchy() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView()

        performAsyncTests(
            block: { e in
                updater.performUpdates(target: tableView, adapter: adapter, data: [Section(id: TestID.a)]) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(adapter.data.count, 1)
                XCTAssertTrue(tableView.isReloadDataCalled)
        })
    }

    func testReloadDataFallbackIfOverAnimatableChangeCount() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView().addingToWindow()
        let stagedChangeset: StagedDataChangeset = [
            DataChangeset(data: [], sectionDeleted: [0]),
            DataChangeset(data: [], sectionInserted: [1, 2])
        ]

        updater.animatableChangeCount = 1

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: tableView, adapter: adapter, data: [], stagedChangeset: stagedChangeset) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertTrue(tableView.isReloadDataCalled)
                XCTAssertEqual(tableView.deletedSections, [])
                XCTAssertEqual(tableView.insertedSections, [])
        })
    }

    func testNopAndCompletion() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView().addingToWindow()

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: tableView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: []) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(adapter.data.count, 1)
                XCTAssertFalse(tableView.hasChanges)
                XCTAssertFalse(tableView.isReloadDataCalled)
        })
    }

    func testDifferentialUpdates() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView().addingToWindow()

        // Rendering visible components is no needed in this test.
        updater.alwaysRenderVisibleComponents = false

        let stagedChangeset: StagedDataChangeset = [
            DataChangeset(data: [], sectionDeleted: [0, 1]),
            DataChangeset(data: [], sectionInserted: [2, 3]),
            DataChangeset(data: [], sectionUpdated: [4, 5]),
            DataChangeset(data: [], sectionMoved: [(source: 6, target: 7)]),
            DataChangeset(data: [], elementDeleted: [ElementPath(element: 8, section: 9)]),
            DataChangeset(data: [], elementInserted: [ElementPath(element: 10, section: 11)]),
            DataChangeset(data: [], elementUpdated: [ElementPath(element: 12, section: 13)]),
            DataChangeset(data: [], elementMoved: [(source: ElementPath(element: 14, section: 15), target: ElementPath(element: 16, section: 17))])
        ]

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: tableView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: stagedChangeset) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(tableView.deletedSections, [0, 1])
                XCTAssertEqual(tableView.insertedSections, [2, 3])
                XCTAssertEqual(tableView.reloadedSections, [4, 5])
                XCTAssertEqual(tableView.movedSections.map(Pair.init), [Pair(6, 7)])
                XCTAssertEqual(tableView.deletedRows, [IndexPath(row: 8, section: 9)])
                XCTAssertEqual(tableView.insertedRows, [IndexPath(row: 10, section: 11)])
                XCTAssertEqual(tableView.reloadedRows, [IndexPath(row: 12, section: 13)])
                XCTAssertEqual(tableView.movedRows.map(Pair.init), [Pair(IndexPath(row: 14, section: 15), IndexPath(row: 16, section: 17))])
                XCTAssertFalse(tableView.isReloadDataCalled)
        })
    }

    func testAlwaysRenderVisibleComponents() {
        let updater = MockTableViewUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView().addingToWindow()

        let visible = (
            header: UITableViewComponentHeaderFooterView(reuseIdentifier: nil),
            cell: UITableViewComponentCell(style: .default, reuseIdentifier: nil),
            footer: UITableViewComponentHeaderFooterView(reuseIdentifier: nil),
            component: MockIdentifiableComponent(id: TestID.a),
            indexPath: IndexPath(item: 0, section: 0)
        )
        let unvisible = (
            header: UITableViewComponentHeaderFooterView(reuseIdentifier: nil),
            cell: UITableViewComponentCell(style: .default, reuseIdentifier: nil),
            footer: UITableViewComponentHeaderFooterView(reuseIdentifier: nil),
            component: MockIdentifiableComponent(id: TestID.b),
            indexPath: IndexPath(item: 0, section: 1)
        )

        let data = [visible, unvisible].map { mock in
            Section(
                id: TestID.a,
                header: ViewNode(mock.component),
                cells: [
                    CellNode(mock.component)
                ],
                footer: ViewNode(mock.component)
            )
        }

        tableView.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
        tableView.customNumberOfSections = data.count
        tableView.customIndexPathsForVisibleRows = [visible.indexPath]
        tableView.customCellForRowAt = { indexPath in
            indexPath == visible.indexPath ? visible.cell : unvisible.cell
        }
        tableView.customHeaderViewForSection = { section in
            section == visible.indexPath.section ? visible.header : unvisible.header
        }
        tableView.customFooterViewForSection = { section in
            section == visible.indexPath.section ? visible.footer : unvisible.footer
        }
        tableView.customRectForSection = { section in
            let y: CGFloat = section == visible.indexPath.section ? 0 : 1000
            return CGRect(x: 0, y: y, width: 500, height: 500)
        }

        XCTAssertNil(visible.cell.renderedComponent)
        XCTAssertNil(visible.header.renderedComponent)
        XCTAssertNil(visible.footer.renderedComponent)

        updater.performDifferentialUpdates(target: tableView, adapter: adapter, data: data, stagedChangeset: [], completion: nil)

        XCTAssertEqual(visible.component, visible.cell.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertEqual(visible.component, visible.header.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertEqual(visible.component, visible.footer.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertNil(unvisible.cell.renderedComponent)
        XCTAssertNil(unvisible.header.renderedComponent)
        XCTAssertNil(unvisible.footer.renderedComponent)
    }
}
