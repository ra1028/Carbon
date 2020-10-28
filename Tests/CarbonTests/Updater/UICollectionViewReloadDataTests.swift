import XCTest
import DifferenceKit
@testable import Carbon

final class UICollectionViewReloadDataTests: XCTestCase {
    func testPrepare() {
        let updater = MockCollectionViewReloadDataUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        updater.prepare(target: collectionView, adapter: adapter)

        XCTAssertTrue(collectionView.isReloadDataCalled)
        XCTAssertEqual(collectionView.delegate as? MockCollectionViewFlowLayoutAdapter, adapter)
        XCTAssertEqual(collectionView.dataSource as? MockCollectionViewFlowLayoutAdapter, adapter)
    }

    func testPerformUpdates() {
        let updater = MockCollectionViewReloadDataUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()

        performAsyncTests(
            block: { e in
                updater.performUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)]) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(adapter.data.count, 1)
                XCTAssertTrue(collectionView.isReloadDataCalled)
        })
    }
}
