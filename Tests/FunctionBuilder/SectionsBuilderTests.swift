#if swift(>=5.1)

import XCTest
@testable import Carbon

final class SectionsBuilderTests: XCTestCase {
    func testInit0() {
        let builders = [
            SectionsBuilder(),
            SectionsBuilder.buildBlock()
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertTrue(sections.isEmpty)
        }
    }

    func testInit1() {
        let s = Section(id: 0)
        let builders = [
            SectionsBuilder(s),
            SectionsBuilder.buildBlock(s)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 1)
            XCTAssertEqual(sections[0].id, 0)
        }
    }

    func testInit2() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let builders = [
            SectionsBuilder(s0, s1),
            SectionsBuilder.buildBlock(s0, s1)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 2)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
        }
    }

    func testInit3() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let builders = [
            SectionsBuilder(s0, s1, s2),
            SectionsBuilder.buildBlock(s0, s1, s2)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 3)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
        }
    }

    func testInit4() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3),
            SectionsBuilder.buildBlock(s0, s1, s2, s3)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 4)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
        }
    }

    func testInit5() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 5)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
        }
    }

    func testInit6() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let s5 = Section(id: 5)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4, s5),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4, s5)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 6)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
            XCTAssertEqual(sections[5].id, 5)
        }
    }

    func testInit7() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let s5 = Section(id: 5)
        let s6 = Section(id: 6)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4, s5, s6),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4, s5, s6)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 7)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
            XCTAssertEqual(sections[5].id, 5)
            XCTAssertEqual(sections[6].id, 6)
        }
    }

    func testInit8() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let s5 = Section(id: 5)
        let s6 = Section(id: 6)
        let s7 = Section(id: 7)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4, s5, s6, s7)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 8)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
            XCTAssertEqual(sections[5].id, 5)
            XCTAssertEqual(sections[6].id, 6)
            XCTAssertEqual(sections[7].id, 7)
        }
    }

    func testInit9() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let s5 = Section(id: 5)
        let s6 = Section(id: 6)
        let s7 = Section(id: 7)
        let s8 = Section(id: 8)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7, s8),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4, s5, s6, s7, s8)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 9)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
            XCTAssertEqual(sections[5].id, 5)
            XCTAssertEqual(sections[6].id, 6)
            XCTAssertEqual(sections[7].id, 7)
            XCTAssertEqual(sections[8].id, 8)
        }
    }

    func testInit10() {
        let s0 = Section(id: 0)
        let s1 = Section(id: 1)
        let s2 = Section(id: 2)
        let s3 = Section(id: 3)
        let s4 = Section(id: 4)
        let s5 = Section(id: 5)
        let s6 = Section(id: 6)
        let s7 = Section(id: 7)
        let s8 = Section(id: 8)
        let s9 = Section(id: 9)
        let builders = [
            SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9),
            SectionsBuilder.buildBlock(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9)
        ]

        for builder in builders {
            let sections = builder.buildSections()

            XCTAssertEqual(sections.count, 10)
            XCTAssertEqual(sections[0].id, 0)
            XCTAssertEqual(sections[1].id, 1)
            XCTAssertEqual(sections[2].id, 2)
            XCTAssertEqual(sections[3].id, 3)
            XCTAssertEqual(sections[4].id, 4)
            XCTAssertEqual(sections[5].id, 5)
            XCTAssertEqual(sections[6].id, 6)
            XCTAssertEqual(sections[7].id, 7)
            XCTAssertEqual(sections[8].id, 8)
            XCTAssertEqual(sections[9].id, 9)
        }
    }
}

#endif
