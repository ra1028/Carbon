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
