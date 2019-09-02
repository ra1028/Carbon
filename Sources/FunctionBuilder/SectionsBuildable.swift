public protocol SectionsBuildable {
    func buildSections() -> [Section]
}

extension Optional: SectionsBuildable where Wrapped: SectionsBuildable {
    public func buildSections() -> [Section] {
        self?.buildSections() ?? []
    }
}
