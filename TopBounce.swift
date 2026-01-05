import Cocoa
import CoreGraphics

let topLimit: CGFloat = 8
let enableShiftBypass = true

var eventTap: CFMachPort?

func eventCallback(proxy: CGEventTapProxy,
                   type: CGEventType,
                   event: CGEvent,
                   refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    guard type == .mouseMoved || type == .leftMouseDragged else {
        return Unmanaged.passUnretained(event)
    }

    // Shift bypass
    if enableShiftBypass && event.flags.contains(.maskShift) {
        return Unmanaged.passUnretained(event)
    }

    let location = event.location

    // If cursor would go above limit, modify the event to clamp it
    if location.y < topLimit {
        // Create a new location with Y clamped to topLimit
        event.location = CGPoint(x: location.x, y: topLimit)
    }

    return Unmanaged.passUnretained(event)
}

func main() {
    let trusted = AXIsProcessTrusted()
    if !trusted {
        print("⚠️  Needs Accessibility permissions.")
        exit(1)
    }

    let mask = (1 << CGEventType.mouseMoved.rawValue) |
               (1 << CGEventType.leftMouseDragged.rawValue)

    eventTap = CGEvent.tapCreate(
        tap: .cghidEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: CGEventMask(mask),
        callback: eventCallback,
        userInfo: nil
    )

    guard let tap = eventTap else {
        print("❌ Failed to create event tap.")
        exit(1)
    }

    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)

    print("✅ Menu bar blocker active (event modification, no warp)")
    print("   Clamps Y to minimum \(Int(topLimit))px")
    print("   Hold Shift to bypass")

    CFRunLoopRun()
}

main()
