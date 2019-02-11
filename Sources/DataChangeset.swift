import DifferenceKit

/// A set of changes in the collection of sections.
public typealias DataChangeset = Changeset<[Section]>

/// An ordered collection of `DataChangeset` as staged set of changes
/// in the collection of sections.
public typealias StagedDataChangeset = StagedChangeset<[Section]>
