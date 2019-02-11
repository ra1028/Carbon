import XCTest
@testable import Carbon

final class UITableViewAdapterTests: XCTestCase {
    func testNumberOfSections() {
        let adapter = UITableViewAdapter()
        adapter.data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            Section(id: TestID.c)
        ]

        XCTAssertEqual(adapter.numberOfSections(in: UITableView()), 3)
    }

    func testNumberOfRowsInSection() {
        let adapter = UITableViewAdapter()
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

        XCTAssertEqual(adapter.tableView(UITableView(), numberOfRowsInSection: 0), 2)
        XCTAssertEqual(adapter.tableView(UITableView(), numberOfRowsInSection: 1), 1)
    }

    func testCellForRow() {
        let config = UITableViewAdapter.Config(cellClass: MockTableViewCell.self)
        let adapter = UITableViewAdapter(config: config)
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [CellNode(component)]
            )
        ]

        let cell = adapter.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))

        if
            let testCell = cell as? MockTableViewCell,
            let renderedContent = testCell.renderedContent,
            let renderedComponent = testCell.renderedComponent {
            XCTAssertTrue(testCell.isMember(of: MockTableViewCell.self))
            XCTAssertTrue(renderedContent is A.Component.Content)
            XCTAssertEqual(renderedComponent.as(A.Component.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testViewForHeader() {
        let config = UITableViewAdapter.Config(headerViewClass: MockTableViewHeaderFooterView.self)
        let adapter = UITableViewAdapter(config: config)
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                header: ViewNode(component)
            )
        ]

        let view = adapter.tableView(UITableView(), viewForHeaderInSection: 0)

        if
            let testView = view as? MockTableViewHeaderFooterView,
            let renderedContent = testView.renderedContent,
            let renderedComponent = testView.renderedComponent {
            XCTAssertTrue(testView.isMember(of: MockTableViewHeaderFooterView.self))
            XCTAssertTrue(renderedContent is A.Component.Content)
            XCTAssertEqual(renderedComponent.as(A.Component.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testViewForFooter() {
        let config = UITableViewAdapter.Config(footerViewClass: MockTableViewHeaderFooterView.self)
        let adapter = UITableViewAdapter(config: config)
        let component = A.Component()
        adapter.data = [
            Section(
                id: TestID.a,
                footer: ViewNode(component)
            )
        ]

        let view = adapter.tableView(UITableView(), viewForFooterInSection: 0)

        if
            let testView = view as? MockTableViewHeaderFooterView,
            let renderedContent = testView.renderedContent,
            let renderedComponent = testView.renderedComponent {
            XCTAssertTrue(testView.isMember(of: MockTableViewHeaderFooterView.self))
            XCTAssertTrue(renderedContent is A.Component.Content)
            XCTAssertEqual(renderedComponent.as(A.Component.self), component)
        }
        else {
            XCTFail()
        }
    }

    func testHeightForRow() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.rowHeight = defaultHeight
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [
                    CellNode(id: TestID.a, MockComponent(referenceSize: referenceSize)),
                    CellNode(id: TestID.b, MockComponent(referenceSize: nil))
                ]
            )
        ]

        let height1 = adapter.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        let height2 = adapter.tableView(tableView, heightForRowAt: IndexPath(row: 1, section: 0))

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
    }

    func testEstimatedHeightForRow() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.estimatedRowHeight = defaultHeight
        adapter.data = [
            Section(
                id: TestID.a,
                cells: [
                    CellNode(id: TestID.a, MockComponent(referenceSize: referenceSize)),
                    CellNode(id: TestID.b, MockComponent(referenceSize: nil))
                ]
            )
        ]

        let height1 = adapter.tableView(tableView, estimatedHeightForRowAt: IndexPath(row: 0, section: 0))
        let height2 = adapter.tableView(tableView, estimatedHeightForRowAt: IndexPath(row: 1, section: 0))

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
    }

    func testHeightForHeader() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.sectionHeaderHeight = defaultHeight
        adapter.data = [
            Section(id: TestID.a, header: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, header: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, header: nil)
        ]

        let height1 = adapter.tableView(tableView, heightForHeaderInSection: 0)
        let height2 = adapter.tableView(tableView, heightForHeaderInSection: 1)
        let height3 = adapter.tableView(tableView, heightForHeaderInSection: 2)

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
        XCTAssertGreaterThan(height3, 0)
    }

    func testEstimatedHeightForHeader() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.estimatedSectionHeaderHeight = defaultHeight
        adapter.data = [
            Section(id: TestID.a, header: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, header: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, header: nil)
        ]

        let height1 = adapter.tableView(tableView, estimatedHeightForHeaderInSection: 0)
        let height2 = adapter.tableView(tableView, estimatedHeightForHeaderInSection: 1)
        let height3 = adapter.tableView(tableView, estimatedHeightForHeaderInSection: 2)

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
        XCTAssertGreaterThan(height3, 0)
    }

    func testHeightForFooter() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.sectionFooterHeight = defaultHeight
        adapter.data = [
            Section(id: TestID.a, footer: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, footer: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, footer: nil)
        ]

        let height1 = adapter.tableView(tableView, heightForFooterInSection: 0)
        let height2 = adapter.tableView(tableView, heightForFooterInSection: 1)
        let height3 = adapter.tableView(tableView, heightForFooterInSection: 2)

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
        XCTAssertGreaterThan(height3, 0)
    }

    func testEstimatedHeightForFooter() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let referenceSize = CGSize(width: 100, height: 200)
        let defaultHeight: CGFloat = 300

        tableView.estimatedSectionFooterHeight = defaultHeight
        adapter.data = [
            Section(id: TestID.a, footer: ViewNode(MockComponent(referenceSize: referenceSize))),
            Section(id: TestID.b, footer: ViewNode(MockComponent(referenceSize: nil))),
            Section(id: TestID.c, footer: nil)
        ]

        let height1 = adapter.tableView(tableView, estimatedHeightForFooterInSection: 0)
        let height2 = adapter.tableView(tableView, estimatedHeightForFooterInSection: 1)
        let height3 = adapter.tableView(tableView, estimatedHeightForFooterInSection: 2)

        XCTAssertEqual(height1, referenceSize.height)
        XCTAssertEqual(height2, defaultHeight)
        XCTAssertGreaterThan(height3, 0)
    }

    func testDidSelect() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let indexPath = IndexPath(row: 0, section: 0)
        let node = CellNode(MockIdentifiableComponent(id: TestID.a))
        var context: UITableViewAdapter.SelectionContext?

        adapter.data = [
            Section(
                id: TestID.a,
                cells: [node]
            )
        ]

        adapter.didSelect = { context = $0 }
        adapter.tableView(tableView, didSelectRowAt: indexPath)

        if let context = context {
            XCTAssertEqual(context.indexPath, indexPath)
            XCTAssertEqual(context.tableView, tableView)
            XCTAssertTrue(context.node.isContentEqual(to: node))
        }
        else {
            XCTFail()
        }
    }

    func testDisplaying() {
        let adapter = UITableViewAdapter()
        let tableView = UITableView()
        let headerComponent = MockComponent()
        let cellComponent = MockIdentifiableComponent(id: TestID.a)
        let footerComponent = MockComponent()

        adapter.data = [
            Section(
                id: TestID.a,
                header: ViewNode(headerComponent),
                cells: [CellNode(cellComponent)],
                footer: ViewNode(footerComponent)
            )
        ]

        let cell = adapter.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let headerView = adapter.tableView(tableView, viewForHeaderInSection: 0)!
        let footerView = adapter.tableView(tableView, viewForFooterInSection: 0)!

        adapter.tableView(tableView, willDisplay: cell, forRowAt: IndexPath(row: 0, section: 0))
        adapter.tableView(tableView, didEndDisplaying: cell, forRowAt: IndexPath(row: 0, section: 0))
        adapter.tableView(tableView, willDisplayHeaderView: headerView, forSection: 0)
        adapter.tableView(tableView, didEndDisplayingHeaderView: headerView, forSection: 0)
        adapter.tableView(tableView, willDisplayFooterView: footerView, forSection: 0)
        adapter.tableView(tableView, didEndDisplayingFooterView: footerView, forSection: 0)

        XCTAssertEqual(renderedContent(of: cell, as: MockComponent.Content.self), cellComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: cell, as: MockComponent.Content.self), cellComponent.contentCapturedOnDidEndDisplay)
        XCTAssertEqual(renderedContent(of: headerView, as: MockComponent.Content.self), headerComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: headerView, as: MockComponent.Content.self), headerComponent.contentCapturedOnDidEndDisplay)
        XCTAssertEqual(renderedContent(of: footerView, as: MockComponent.Content.self), footerComponent.contentCapturedOnWillDisplay)
        XCTAssertEqual(renderedContent(of: footerView, as: MockComponent.Content.self), footerComponent.contentCapturedOnDidEndDisplay)
    }
}
