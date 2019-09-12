import XCTest
@testable import Carbon

final class IdentifiableComponentTests: XCTestCase {
    func testHashable() {
        let component = A.Component()

        XCTAssertEqual(component.id, component)
        XCTAssertEqual(component.id.hashValue, component.hashValue)
    }

    func testBuildCells() {
        let component = A.Component(value: 100)
        let cells = component.buildCells()

        XCTAssertEqual(cells.count, 1)
        XCTAssertEqual(cells[0].component(as: A.Component.self)?.value, 100)
    }
}
