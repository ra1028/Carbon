import XCTest
@testable import Carbon

final class RendererTests: XCTestCase {
    func testTargetWeakCapture() {
        var target: MockTarget? = MockTarget()
        let renderer = Renderer(
            adapter: MockAdapter(),
            updater: MockUpdater()
        )
        renderer.target = target

        target = nil
        XCTAssertNil(renderer.target)
    }

    func testPrepare() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )
        renderer.target = target

        XCTAssertEqual(renderer.updater.targetCapturedOnPrepare, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnPrepare, adapter)
    }

    func testRenderBeforeTargetIsSet() {
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        renderer.render(
            Section(id: TestID.a),
            Section(id: TestID.b)
        )

        XCTAssertEqual(renderer.adapter.data.count, 2)
    }

    func testDataSetter() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        renderer.target = target
        renderer.data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            Section(id: TestID.c)
        ]

        XCTAssertEqual(renderer.adapter.data.count, 3)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }

    func testRenderWithDataCollection() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        let data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            Section(id: TestID.c)
        ]

        renderer.target = target
        renderer.render(data)

        XCTAssertEqual(renderer.adapter.data.count, 3)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }

    func testRenderWithDataCollectionContainingNil() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        let data = [
            Section(id: TestID.a),
            nil,
            Section(id: TestID.b),
            nil,
            Section(id: TestID.c)
        ]

        renderer.target = target
        renderer.render(data)

        XCTAssertEqual(renderer.adapter.data.count, 3)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }

    func testRenderWithVariadicData() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        let data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            Section(id: TestID.c),
            Section(id: TestID.d)
        ]

        renderer.target = target
        renderer.render(data)

        XCTAssertEqual(renderer.adapter.data.count, 4)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }

    func testRenderWithVariadicDataContainingNil() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )

        let data = [
            Section(id: TestID.a),
            Section(id: TestID.b),
            nil,
            Section(id: TestID.c),
            nil,
            Section(id: TestID.d)
        ]

        renderer.target = target
        renderer.render(data)

        XCTAssertEqual(renderer.adapter.data.count, 4)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }
}

#if swift(>=5.1)

extension RendererTests {
    func testRenderWithSectionsBuilder() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )
        let condition = false

        renderer.target = target
        renderer.render {
            Section(id: TestID.a)
            Section(id: TestID.b)
            Section(id: TestID.c)

            if condition {
                Section(id: TestID.d)
            }

            Group {
                Section(id: 100)
                Section(id: 200)
            }
        }

        XCTAssertEqual(renderer.adapter.data.count, 5)
        XCTAssertEqual(renderer.adapter.data[0].id, TestID.a)
        XCTAssertEqual(renderer.adapter.data[1].id, TestID.b)
        XCTAssertEqual(renderer.adapter.data[2].id, TestID.c)
        XCTAssertEqual(renderer.adapter.data[3].id, 100)
        XCTAssertEqual(renderer.adapter.data[4].id, 200)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }

    func testRenderWithCellsBuilder() {
        let target = MockTarget()
        let adapter = MockAdapter()
        let renderer = Renderer(
            adapter: adapter,
            updater: MockUpdater()
        )
        let condition = false

        renderer.target = target
        renderer.render {
            A.Component(value: 0)
            A.Component(value: 1)
            A.Component(value: 2)
            A.Component(value: 3)

            if condition {
                A.Component(value: 4)
            }

            Group {
                A.Component(value: 5)
                A.Component(value: 6)
            }
        }

        XCTAssertEqual(renderer.adapter.data.count, 1)

        let section = renderer.adapter.data[0]
        XCTAssertEqual(section.cells.count, 6)
        XCTAssertEqual(section.cells[0].component(as: A.Component.self)?.value, 0)
        XCTAssertEqual(section.cells[1].component(as: A.Component.self)?.value, 1)
        XCTAssertEqual(section.cells[2].component(as: A.Component.self)?.value, 2)
        XCTAssertEqual(section.cells[3].component(as: A.Component.self)?.value, 3)
        XCTAssertEqual(section.cells[4].component(as: A.Component.self)?.value, 5)
        XCTAssertEqual(section.cells[5].component(as: A.Component.self)?.value, 6)
        XCTAssertEqual(renderer.updater.targetCapturedOnUpdates, target)
        XCTAssertEqual(renderer.updater.adapterCapturedOnUpdates, adapter)
    }
}

#endif
