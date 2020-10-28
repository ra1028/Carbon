public extension Renderer {
    /// Create a new instance with given target, adapter and updater.
    /// Immediately the `prepare` of updater is called.
    @available(*, deprecated, message:"Use the `Renderer.init` that accepts only `adapter` and `updater` parameters, and set `target` at arbitrary timing.")
    convenience init(target: Updater.Target, adapter: Updater.Adapter, updater: Updater) {
        self.init(adapter: adapter, updater: updater)
        self.target = target
        updater.prepare(target: target, adapter: adapter)
    }
}
