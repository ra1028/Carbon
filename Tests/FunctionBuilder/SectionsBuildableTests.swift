import XCTest
@testable import Carbon

final class SectionsBuildableTests: XCTestCase {
    func testBuildSections() {
        let section0 = Section(id: 0)
        let section1 = Section(id: 1)
        let s = MockSectionsBuildable(
            sections: [
                section0,
                section1
            ]
        )
        let sections = s.buildSections()

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].id, 0)
        XCTAssertEqual(sections[1].id, 1)
    }

    func testBuildSectionsFromSome() {
        let section0 = Section(id: 0)
        let section1 = Section(id: 1)
        let s: MockSectionsBuildable? = MockSectionsBuildable(
            sections: [
                section0,
                section1
            ]
        )
        let sections = s.buildSections()

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].id, 0)
        XCTAssertEqual(sections[1].id, 1)
    }

    func testBuildSectionsFromNone() {
        let s: MockSectionsBuildable? = nil
        let sections = s.buildSections()

        XCTAssertTrue(sections.isEmpty)
    }
}
