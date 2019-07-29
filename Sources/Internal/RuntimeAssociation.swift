import ObjectiveC

internal final class RuntimeAssociation<Value> {
    private let key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    private let defaultValue: () -> Value

    deinit {
        key.deinitialize(count: 1)
        key.deallocate()
    }

    init(default defaultValue: @escaping @autoclosure () -> Value) {
        self.defaultValue = defaultValue
    }

    subscript<Owner: AnyObject>(owner: Owner) -> Value {
        get {
            if let object = objc_getAssociatedObject(owner, key) as? Value {
                return object
            }
            else {
                let value = defaultValue()
                self[owner] = value
                return value
            }
        }
        set {
            objc_setAssociatedObject(owner, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
