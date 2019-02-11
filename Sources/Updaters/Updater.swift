/// Represents an updater that manages the updation for target.
public protocol Updater {
    /// A type that represents a target to be updated for render given data.
    associatedtype Target: AnyObject

    /// A type that represents an adapter holding the data to be rendered.
    associatedtype Adapter: Carbon.Adapter

    /// Prepares given target and adapter.
    ///
    /// - Parameters:
    ///   - target: A target to be prepared.
    ///   - adapter: An adapter to be prepared.
    func prepare(target: Target, adapter: Adapter)

    /// Perform updates to render given data to the target.
    /// The completion is expected to be called after all updates
    /// and the its animations.
    ///
    /// - Parameters:
    ///   - target: A target instance to be updated to render given data.
    ///   - adapter: An adapter holding currently rendered data.
    ///   - data: A collection of sections to be rendered next.
    ///   - completion: A closure that to callback end of update.
    func performUpdates(target: Target, adapter: Adapter, data: [Section], completion: (() -> Void)?)
}
