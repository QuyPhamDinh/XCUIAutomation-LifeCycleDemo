import XCTest
import XCUIAutomation

@MainActor
final class WarmResumeTests: DemoUITestCase {
    func testFormsStateSurvivesHomeAndResume() {
        let forms = FormsScreen(app: app)
        let lifecycle = LifecycleActions(app: app)
        forms.open()
        XCTAssertTrue(forms.inputValue.isEmpty || forms.inputValue == "Type something")
        forms.setSwitch(false)
        forms.enter("Draft before switching")
        forms.setSwitch(true)

        lifecycle.goHome()
        let backgrounded = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            self.app.state == .runningBackground || self.app.state == .runningBackgroundSuspended
        }, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [backgrounded], timeout: DemoConfiguration.timeout), .completed)
        lifecycle.resume()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "Draft before switching")
        XCTAssertTrue(forms.isOn)
        forms.setSwitch(false)
    }

    func testFormsStateSurvivesAppSwitcher() {
        let forms = FormsScreen(app: app)
        forms.open()
        forms.enter("iOS draft")
        forms.setSwitch(true)

        // A short, slow swipe from the bottom opens the iOS App Switcher.
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.99))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.48))
        start.press(forDuration: 0.1, thenDragTo: end, withVelocity: .slow, thenHoldForDuration: 0.7)

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let card = springboard.otherElements.matching(
            NSPredicate(format: "label CONTAINS[c] %@", "WDIO")
        ).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: DemoConfiguration.timeout), "Demo app card did not appear in the App Switcher")
        card.tap()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "iOS draft")
        XCTAssertTrue(forms.isOn)
    }
}
