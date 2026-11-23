import XCTest
import XCUIAutomation

@MainActor
struct LifecycleActions {
    let app: XCUIApplication

    func sendToBackground() {
        XCUIDevice.shared.press(.home)
        let backgrounded = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            app.state == .runningBackground || app.state == .runningBackgroundSuspended
        }, object: nil)
        XCTAssertEqual(
            XCTWaiter.wait(for: [backgrounded], timeout: DemoConfiguration.timeout),
            .completed,
            "The app did not enter the background"
        )
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

    func resumeFromAppSwitcher() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let card = springboard.otherElements.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "WDIO")
        ).firstMatch
        XCTAssertTrue(
            card.waitForExistence(timeout: DemoConfiguration.timeout),
            "Demo app card did not appear in the App Switcher"
        )
        card.tap()
    }

    func terminateAndRelaunch() {
        app.terminate()
        app.launch()
    }
}
