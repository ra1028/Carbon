import XCTest
import DifferenceKit
@testable import Carbon

final class UICollectionViewUpdaterTests: XCTestCase {
    func testPrepare() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        updater.prepare(target: collectionView, adapter: adapter)

        XCTAssertTrue(collectionView.isReloadDataCalled)
        XCTAssertEqual(collectionView.delegate as? MockCollectionViewFlowLayoutAdapter, adapter)
        XCTAssertEqual(collectionView.dataSource as? MockCollectionViewFlowLayoutAdapter, adapter)
    }

    func testReloadDataFallbackIfNotInViewHierarchy() {
        let updater = MockCollectionViewUpdater()
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

    func testReloadDataFallbackIfOverAnimatableChangeCount() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()
        let stagedChangeset: StagedDataChangeset = [
            DataChangeset(data: [], sectionDeleted: [0]),
            DataChangeset(data: [], sectionInserted: [1, 2])
        ]

        updater.animatableChangeCount = 1

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [], stagedChangeset: stagedChangeset) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertTrue(collectionView.isReloadDataCalled)
                XCTAssertEqual(collectionView.deletedSections, [])
                XCTAssertEqual(collectionView.insertedSections, [])
        })
    }

    func testNopAndCompletion() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: []) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(adapter.data.count, 1)
                XCTAssertFalse(collectionView.hasChanges)
                XCTAssertFalse(collectionView.isReloadDataCalled)
        })
    }

    func testDifferentialUpdates() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()

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
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: stagedChangeset) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(collectionView.deletedSections, [0, 1])
                XCTAssertEqual(collectionView.insertedSections, [2, 3])
                XCTAssertEqual(collectionView.reloadedSections, [4, 5])
                XCTAssertEqual(collectionView.movedSections.map(Pair.init), [Pair(6, 7)])
                XCTAssertEqual(collectionView.deletedItems, [IndexPath(row: 8, section: 9)])
                XCTAssertEqual(collectionView.insertedItems, [IndexPath(row: 10, section: 11)])
                XCTAssertEqual(collectionView.reloadedItems, [IndexPath(row: 12, section: 13)])
                XCTAssertEqual(collectionView.movedItems.map(Pair.init), [Pair(IndexPath(row: 14, section: 15), IndexPath(row: 16, section: 17))])
                XCTAssertFalse(collectionView.isReloadDataCalled)
        })
    }

    func testSkipReloadComponents() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()

        let stagedChangeset: StagedDataChangeset = [
            DataChangeset(data: [], elementUpdated: [ElementPath(element: 0, section: 0)])
        ]

        updater.skipReloadComponents = true

        performAsyncTests(
            block: { e in
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: stagedChangeset) {
                    e.fulfill()
                }},
            testing: {
                XCTAssertEqual(collectionView.reloadedItems, [])
                XCTAssertFalse(collectionView.isReloadDataCalled)
        })
    }

    func testAlwaysRenderVisibleComponents() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()
        let header = MockCollectionReusableView(frame: .zero)
        let cell = MockCollectionViewCell(frame: .zero)
        let footer = MockCollectionReusableView(frame: .zero)
        let component = MockIdentifiableComponent(id: TestID.b)
        let data = [
            Section(
                id: TestID.a,
                header: ViewNode(component),
                cells: [
                    CellNode(component)
                ],
                footer: ViewNode(component)
            )
        ]

        collectionView.customIndexPathsForVisibleItems = [IndexPath(item: 0, section: 0)]
        collectionView.customIndexPathsForVisibleSupplementaryElementsOfKind = { _ in [IndexPath(item: 0, section: 0)] }
        collectionView.customCellForItemAt = { _ in cell }
        collectionView.customSupplementaryViewForElementKindAt = { kind, _ in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return header
            case UICollectionView.elementKindSectionFooter:
                return footer
            default:
                return nil
            }
        }

        updater.alwaysRenderVisibleComponents = true

        XCTAssertNil(cell.renderedComponent)

        updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: data, stagedChangeset: [], completion: nil)

        if
            let cellComponent = cell.renderedComponent?.as(MockIdentifiableComponent<TestID>.self),
            let headerComponent = header.renderedComponent?.as(MockIdentifiableComponent<TestID>.self),
            let footerComponent = footer.renderedComponent?.as(MockIdentifiableComponent<TestID>.self) {
            XCTAssertEqual(cellComponent, component)
            XCTAssertEqual(headerComponent, component)
            XCTAssertEqual(footerComponent, component)
        }
        else {
            XCTFail()
        }
    }
}
