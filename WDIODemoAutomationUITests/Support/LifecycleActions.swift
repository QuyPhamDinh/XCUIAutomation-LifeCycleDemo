import XCTest
import XCUIAutomation

@MainActor
struct LifecycleActions {
    let app: XCUIApplication

    @discardableResult
    func sendToBackground(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        XCUIDevice.shared.press(.home)
        let backgrounded = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            app.state == .runningBackground || app.state == .runningBackgroundSuspended
        }, object: nil)
        let result = XCTWaiter.wait(for: [backgrounded], timeout: DemoConfiguration.timeout)
        if result != .completed {
            XCTFail("The app did not enter the background", file: file, line: line)
            return false
        }
        return true
    }

    func resume() {
        app.activate()
    }

    func openAppSwitcher() {
        // A short, slow swipe from the bottom opens the iOS App Switcher.
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.99))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.48))
        start.press(forDuration: 0.1, thenDragTo: end, withVelocity: .slow, thenHoldForDuration: 0.7)
    }

    @discardableResult
    func resumeFromAppSwitcher(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let card = springboard.otherElements.matching(
            NSPredicate(format: "label CONTAINS[c] %@", DemoConfiguration.appSwitcherLabel)
        ).firstMatch
        return card.tapWhenReady(
            message: "App card matching \(DemoConfiguration.appSwitcherLabel) did not appear in the App Switcher",
            file: file,
            line: line
        )
    }

    func terminateAndRelaunch() {
        app.terminate()
        app.launch()
    }
}
