import CAdwaita

private struct SendableOpaqueBoxPointer: @unchecked Sendable {
    let value: UnsafeMutableRawPointer
}

public func scheduleDeferredBoxRelease(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    let sendablePointer = SendableOpaqueBoxPointer(value: userData)
    Task { @MainActor in
        Unmanaged<AnyObject>.fromOpaque(sendablePointer.value).release()
    }
}

public func deferredBoxDestroyNotify(_ userData: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?) {
    scheduleDeferredBoxRelease(userData)
}
