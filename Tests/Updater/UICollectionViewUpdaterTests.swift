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
                updater.completion = e.fulfill
                updater.performUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)])
        },
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
                updater.completion = e.fulfill
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [], stagedChangeset: stagedChangeset)
        },
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
                updater.completion = e.fulfill
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: [])
        },
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
                updater.completion = e.fulfill
                updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: [Section(id: TestID.a)], stagedChangeset: stagedChangeset)
        },
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

    func testAlwaysRenderVisibleComponents() {
        let updater = MockCollectionViewUpdater()
        let adapter = MockCollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView().addingToWindow()

        let visible = (
            header: UICollectionComponentReusableView(frame: .zero),
            cell: UICollectionViewComponentCell(frame: .zero),
            footer: UICollectionComponentReusableView(frame: .zero),
            component: MockIdentifiableComponent(id: TestID.a),
            indexPath: IndexPath(item: 0, section: 0)
        )
        let unvisible = (
            header: UICollectionComponentReusableView(frame: .zero),
            cell: UICollectionViewComponentCell(frame: .zero),
            footer: UICollectionComponentReusableView(frame: .zero),
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

        collectionView.customIndexPathsForVisibleItems = [visible.indexPath]
        collectionView.customIndexPathsForVisibleSupplementaryElementsOfKind = { _ in [visible.indexPath] }
        collectionView.customCellForItemAt = { indexPath in
            indexPath == visible.indexPath ? visible.cell : unvisible.cell
        }
        collectionView.customSupplementaryViewForElementKindAt = { kind, indexPath in
            let isVisible = indexPath.section == visible.indexPath.section
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return isVisible ? visible.header : unvisible.header
            case UICollectionView.elementKindSectionFooter:
                return isVisible ? visible.footer : unvisible.footer
            default:
                return nil
            }
        }

        // Register cell and header, footer.
        adapter.data = data
        _ = adapter.collectionView(collectionView, cellForItemAt: visible.indexPath)
        _ = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: visible.indexPath)
        _ = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: visible.indexPath)

        XCTAssertNil(visible.cell.renderedComponent)
        XCTAssertNil(visible.header.renderedComponent)
        XCTAssertNil(visible.footer.renderedComponent)

        updater.performDifferentialUpdates(target: collectionView, adapter: adapter, data: data, stagedChangeset: [])

        XCTAssertEqual(visible.component, visible.cell.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertEqual(visible.component, visible.header.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertEqual(visible.component, visible.footer.renderedComponent?.as(MockIdentifiableComponent<TestID>.self))
        XCTAssertNil(unvisible.cell.renderedComponent)
        XCTAssertNil(unvisible.header.renderedComponent)
        XCTAssertNil(unvisible.footer.renderedComponent)
    }
}
