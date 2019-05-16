import ObjectiveC

internal final class RuntimeAssociation<Value> {
    private let key = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)

    deinit {
        key.deinitialize(count: 1)
        key.deallocate()
    }

    internal func value<Owner: AnyObject>(for owner: Owner, default defaultValue: @autoclosure () -> Value) -> Value {
        if let object = objc_getAssociatedObject(owner, key) as? Value {
            return object
        }
        else {
            let value = defaultValue()
            set(value: value, for: owner)
            return value
        }
    }

    internal func set<Owner: AnyObject>(value: Value, for owner: Owner) {
        objc_setAssociatedObject(owner, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
