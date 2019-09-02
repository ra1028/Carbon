// swiftlint:disable line_length
// swiftlint:disable function_parameter_count

@_functionBuilder
public struct SectionsBuilder: SectionsBuildable {
    private var sections: [Section]

    public func buildSections() -> [Section] {
        sections
    }

    public static func buildBlock() -> SectionsBuilder {
        SectionsBuilder()
    }

    public static func buildBlock<S: SectionsBuildable>(_ c: S) -> SectionsBuilder {
        SectionsBuilder(c)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable>(_ s0: S0, _ s1: S1) -> SectionsBuilder {
        SectionsBuilder(s0, s1)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4, s5)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4, s5, s6)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable, S8: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7, _ s8: S8) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7, s8)
    }

    public static func buildBlock<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable, S8: SectionsBuildable, S9: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7, _ s8: S8, _ s9: S9) -> SectionsBuilder {
        SectionsBuilder(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9)
    }

    public static func buildIf<S: SectionsBuildable>(_ s: S?) -> S? {
        s
    }

    public static func buildEither<S: SectionsBuildable>(first: S) -> S {
        first
    }

    public static func buildEither<S: SectionsBuildable>(second: S) -> S {
        second
    }
}

private extension SectionsBuilder {
    init() {
        sections = []
    }

    init<S: SectionsBuildable>(_ s: S) {
        sections = s.buildSections()
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable>(_ s0: S0, _ s1: S1) {
        sections = s0.buildSections() + s1.buildSections()
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2) {
        sections = s0.buildSections() + s1.buildSections() + s2.buildSections()
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections()
        sections = sections0 + sections1
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections()
        sections = sections0 + sections1
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections() + s5.buildSections()
        sections = sections0 + sections1
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections() + s5.buildSections()
        let sections2 = s6.buildSections()
        sections = sections0 + sections1 + sections2
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections() + s5.buildSections()
        let sections2 = s6.buildSections() + s7.buildSections()
        sections = sections0 + sections1 + sections2
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable, S8: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7, _ s8: S8) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections() + s5.buildSections()
        let sections2 = s6.buildSections() + s7.buildSections() + s8.buildSections()
        sections = sections0 + sections1 + sections2
    }

    init<S0: SectionsBuildable, S1: SectionsBuildable, S2: SectionsBuildable, S3: SectionsBuildable, S4: SectionsBuildable, S5: SectionsBuildable, S6: SectionsBuildable, S7: SectionsBuildable, S8: SectionsBuildable, S9: SectionsBuildable>(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5, _ s6: S6, _ s7: S7, _ s8: S8, _ s9: S9) {
        let sections0 = s0.buildSections() + s1.buildSections() + s2.buildSections()
        let sections1 = s3.buildSections() + s4.buildSections() + s5.buildSections()
        let sections2 = s6.buildSections() + s7.buildSections() + s8.buildSections()
        sections = sections0 + sections1 + sections2 + s9.buildSections()
    }
}
