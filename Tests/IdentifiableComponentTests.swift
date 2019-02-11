import XCTest
@testable import Carbon

final class IdentifiableComponentTests: XCTestCase {
    func testHashable() {
        let component = A.Component()

        XCTAssertEqual(component.id, component)
        XCTAssertEqual(component.id.hashValue, component.hashValue)
    }
}
