import XCTest
import XCUIAutomation

@MainActor
struct AlertComponent {
    let app: XCUIApplication

    func assertAndDismissAlert(title: String) {
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertTrue(alert.label.contains(title), "Expected alert containing: \(title); got: \(alert.label)")
        alert.buttons["OK"].tap()
        XCTAssertTrue(alert.waitForNonExistence(timeout: DemoConfiguration.timeout))
    }
}
