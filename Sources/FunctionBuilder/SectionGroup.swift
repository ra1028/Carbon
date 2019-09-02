public struct SectionGroup: SectionsBuildable {
    private var _buildSections: () -> [Section]

    public init<S: SectionsBuildable>(@SectionsBuilder _ sections: @escaping () -> S) {
        _buildSections = sections().buildSections
    }

    public init<Seq: Sequence, S: SectionsBuildable>(of sequence: Seq, section: @escaping (Seq.Element) -> S) {
        _buildSections = {
            sequence.flatMap { element in
                section(element).buildSections()
            }
        }
    }

    public func buildSections() -> [Section] {
        _buildSections()
    }
}
