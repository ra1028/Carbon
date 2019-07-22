import XCTest
@testable import Carbon

final class UICollectionViewFlowLayoutAdapterTests: XCTestCase {
    func testNumberOfSections() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        adapter.data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            Section(id: TestID.c)
        ]

        XCTAssertEqual(adapter.numberOfSections(in: MockCollectionView()), 3)
    }

    func testNumberOfItemsInSection() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [
                    CellNode(A.Component()),
                    CellNode(A.Component())
                ]
            ),
            Section(
                id: TestID.b,
                cells: [
                    CellNode(A.Component())
                ]
            )
        ]

        XCTAssertEqual(adapter.collectionView(MockCollectionView(), numberOfItemsInSection: 0), 2)
        XCTAssertEqual(adapter.collectionView(MockCollectionView(), numberOfItemsInSection: 1), 1)
    }

    func testCellForItem() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [CellNode(component)]
            )
        ]

        let collectionView = MockCollectionView()
        collectionView.dataSource = adapter
        let cell = adapter.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))

        if
            let testCell = cell as? UICollectionViewComponentCell,
            let renderedContent = testCell.renderedContent,
            let renderedComponent = testCell.renderedComponent {
            XCTAssertTrue(testCell.isMember(of: UICollectionViewComponentCell.self))
            XCTAssertTrue(renderedContent is  A.Component.Content)
            XCTAssertEqual(renderedComponent.as(A.Component.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testViewForHeader() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let component = MockComponent(referenceSize: CGSize(width: 100, height: 100))
        adapter.data = [
            Section(
                id: TestID.a,
                header: ViewNode(component),
                cells: [
                    CellNode(id: TestID.a, component)
                ]
            )
        ]

        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 500, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        collectionView.layoutIfNeeded()

        let view = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))

        if
            let testView = view as? UICollectionComponentReusableView,
            let renderedContent = testView.renderedContent,
            let renderedComponent = testView.renderedComponent {
            XCTAssertTrue(testView.isMember(of: UICollectionComponentReusableView.self))
            XCTAssertTrue(renderedContent is MockComponent.Content)
            XCTAssertEqual(renderedComponent.as(MockComponent.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testViewForFooter() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let component = MockComponent(referenceSize: CGSize(width: 100, height: 100))
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [
                    CellNode(id: TestID.a, component)
                ],
                footer: ViewNode(component)
            )
        ]

        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 500, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        collectionView.layoutIfNeeded()

        let view = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0))

        if
            let testView = view as? UICollectionComponentReusableView,
            let renderedContent = testView.renderedContent,
            let renderedComponent = testView.renderedComponent {
            XCTAssertTrue(testView.isMember(of: UICollectionComponentReusableView.self))
            XCTAssertTrue(renderedContent is MockComponent.Content)
            XCTAssertEqual(renderedComponent.as(MockComponent.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testSizeForItem() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultSize = CGSize(width: 300, height: 400)

        collectionView.flowLayout.itemSize = defaultSize
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [
                    CellNode(id: TestID.a, MockComponent(referenceSize: referenceSize)),
                    CellNode(id: TestID.b, MockComponent(referenceSize: nil))
                ]
            )
        ]

        let size1 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, sizeForItemAt: IndexPath(item: 0, section: 0))
        let size2 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, sizeForItemAt: IndexPath(item: 1, section: 0))

        XCTAssertEqual(size1, referenceSize)
        XCTAssertEqual(size2, defaultSize)
    }

    func testSizeForHeader() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultSize = CGSize(width: 300, height: 400)

        collectionView.flowLayout.headerReferenceSize = defaultSize
        adapter.data = [
            Section(id: TestID.a, header: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, header: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, header: nil)
        ]

        let size1 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForHeaderInSection: 0)
        let size2 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForHeaderInSection: 1)
        let size3 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForHeaderInSection: 2)

        XCTAssertEqual(size1, referenceSize)
        XCTAssertEqual(size2, defaultSize)
        XCTAssertEqual(size3, .zero)
    }

    func testSizeForFooter() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultSize = CGSize(width: 300, height: 400)

        collectionView.flowLayout.footerReferenceSize = defaultSize
        adapter.data = [
            Section(id: TestID.a, footer: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, footer: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, footer: nil)
        ]

        let size1 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForFooterInSection: 0)
        let size2 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForFooterInSection: 1)
        let size3 = adapter.collectionView(collectionView, layout: collectionView.flowLayout, referenceSizeForFooterInSection: 2)

        XCTAssertEqual(size1, referenceSize)
        XCTAssertEqual(size2, defaultSize)
        XCTAssertEqual(size3, .zero)
    }

    func testDidSelect() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let collectionView = MockCollectionView()
        let indexPath = IndexPath(row: 0, section: 0)
        let node = CellNode(MockIdentifiableComponent(id: TestID.a))
        var context: UICollectionViewFlowLayoutAdapter.SelectionContext?

        adapter.data = [
            Section(
                id: TestID.a,
                cells: [node]
            )
        ]

        adapter.didSelect = { context = $0 }
        adapter.collectionView(collectionView, didSelectItemAt: indexPath)

        if let context = context {
            XCTAssertEqual(context.indexPath, indexPath)
            XCTAssertEqual(context.collectionView, collectionView)
            XCTAssertTrue(context.node.isContentEqual(to: node))
        }
        else {
            XCTFail()
        }
    }

    func testDisplaying() {
        let adapter = UICollectionViewFlowLayoutAdapter()
        let headerComponent = MockComponent(referenceSize: CGSize(width: 100, height: 100))
        let cellComponent = MockIdentifiableComponent(id: TestID.a)
        let footerComponent = MockComponent(referenceSize: CGSize(width: 100, height: 100))
        let indexPath = IndexPath(item: 0, section: 0)

        adapter.data = [
            Section(
                id: TestID.a,
                header: ViewNode(headerComponent),
                cells: [CellNode(cellComponent)],
                footer: ViewNode(footerComponent)
            )
        ]

        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 500, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        collectionView.layoutIfNeeded()

        let cell = adapter.collectionView(collectionView, cellForItemAt: indexPath)
        let headerView = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let footerView = adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)

        adapter.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        adapter.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
        adapter.collectionView(collectionView, willDisplaySupplementaryView: headerView, forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        adapter.collectionView(collectionView, didEndDisplayingSupplementaryView: headerView, forElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        adapter.collectionView(collectionView, willDisplaySupplementaryView: footerView, forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath)
        adapter.collectionView(collectionView, didEndDisplayingSupplementaryView: footerView, forElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)

        XCTAssertEqual(renderedContent(of: cell, as: MockComponent.Content.self), cellComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: cell, as: MockComponent.Content.self), cellComponent.contentCapturedOnDidEndDisplay)
        XCTAssertEqual(renderedContent(of: headerView, as: MockComponent.Content.self), headerComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: headerView, as: MockComponent.Content.self), headerComponent.contentCapturedOnDidEndDisplay)
        XCTAssertEqual(renderedContent(of: footerView, as: MockComponent.Content.self), footerComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: footerView, as: MockComponent.Content.self), footerComponent.contentCapturedOnDidEndDisplay)
    }

    func testCustomCell() {
        let adapter = MockCustomCollectionViewAdapter()
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [CellNode(component)]
            )
        ]

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        func check(expectedClass: (UICollectionViewCell & ComponentRenderable).Type) {
            let cell = adapter.collectionView(
                collectionView,
                cellForItemAt: IndexPath(row: 0, section: 0)
            )

            if
                let testCell = cell as? UICollectionViewCell & ComponentRenderable,
                let renderedContent = testCell.renderedContent,
                let renderedComponent = testCell.renderedComponent {
                XCTAssertTrue(testCell.isMember(of: expectedClass))
                XCTAssertTrue(renderedContent is A.Component.Content)
                XCTAssertEqual(renderedComponent.as(A.Component.self), component)
            }
            else {
                XCTFail()
            }
        }

        adapter.cellClass = MockCustomCollectionViewCell1.self
        check(expectedClass: MockCustomCollectionViewCell1.self)

        adapter.cellClass = MockCustomCollectionViewCell2.self
        check(expectedClass: MockCustomCollectionViewCell2.self)
    }

    func testViewForHeaderFooter() {
        let adapter = MockCustomCollectionViewAdapter()
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                header: ViewNode(component),
                footer: ViewNode(component)
            )
        ]

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        collectionView.layoutIfNeeded()

        func check(view: UICollectionReusableView, expectedClass: (UICollectionReusableView & ComponentRenderable).Type) {
            if
                let testView = view as? UICollectionReusableView & ComponentRenderable,
                let renderedContent = testView.renderedContent,
                let renderedComponent = testView.renderedComponent {
                XCTAssertTrue(testView.isMember(of: expectedClass))
                XCTAssertTrue(renderedContent is A.Component.Content)
                XCTAssertEqual(renderedComponent.as(A.Component.self), component)
            }
            else {
                XCTFail()
            }
        }

        func checkHeader(expectedClass: (UICollectionReusableView & ComponentRenderable).Type) {
            let view = adapter.collectionView(
                collectionView,
                viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(row: 0, section: 0)
            )
            check(view: view, expectedClass: expectedClass)
        }

        func checkFooter(expectedClass: (UICollectionReusableView & ComponentRenderable).Type) {
            let view = adapter.collectionView(
                collectionView,
                viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(row: 0, section: 0)
            )
            check(view: view, expectedClass: expectedClass)
        }

        adapter.supplementaryViewClasses[UICollectionView.elementKindSectionHeader] = MockCustomCollectionViewReusableView1.self
        checkHeader(expectedClass: MockCustomCollectionViewReusableView1.self)

        adapter.supplementaryViewClasses[UICollectionView.elementKindSectionHeader] = MockCustomCollectionViewReusableView2.self
        checkHeader(expectedClass: MockCustomCollectionViewReusableView2.self)

        adapter.supplementaryViewClasses[UICollectionView.elementKindSectionFooter] = MockCustomCollectionViewReusableView1.self
        checkFooter(expectedClass: MockCustomCollectionViewReusableView1.self)

        adapter.supplementaryViewClasses[UICollectionView.elementKindSectionFooter] = MockCustomCollectionViewReusableView2.self
        checkFooter(expectedClass: MockCustomCollectionViewReusableView2.self)
    }
}
