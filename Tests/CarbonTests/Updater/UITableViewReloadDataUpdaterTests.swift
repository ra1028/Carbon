import XCTest
import DifferenceKit
@testable import Carbon

final class UITableViewReloadDataUpdaterTests: XCTestCase {
    func testPrepare() {
        let updater = MockTableViewReloadDataUpdater()
        let adapter = MockTableViewAdapter()
        let tableView = MockTableView()
        updater.prepare(target: tableView, adapter: adapter)

        XCTAssertTrue(tableView.isReloadDataCalled)
        XCTAssertEqual(tableView.delegate as? MockTableViewAdapter, adapter)
        XCTAssertEqual(tableView.dataSource as? MockTableViewAdapter, adapter)
    }

    func testPerformUpdates() {
        let updater = MockTableViewReloadDataUpdater()
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
}
