/// Represents an instance that can build sections.
public protocol SectionsBuildable {
    /// Build an array of section.
    func buildSections() -> [Section]
}

extension Optional: SectionsBuildable where Wrapped: SectionsBuildable {
    /// Build an array of section.
    @inlinable
    public func buildSections() -> [Section] {
        return self?.buildSections() ?? []
    }
}
