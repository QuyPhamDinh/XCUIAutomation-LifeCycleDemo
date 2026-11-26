import XCTest
import XCUIAutomation

@MainActor
struct AlertComponent {
    let app: XCUIApplication

    var alert: XCUIElement { app.alerts.firstMatch }
    var title: String { alert.label }

    func waitForExistence() -> Bool {
        alert.waitForExistence(timeout: DemoConfiguration.timeout)
    }

    func dismiss() {
        alert.buttons["OK"].tap()
    }

    func waitForDismissal() -> Bool {
        alert.waitForNonExistence(timeout: DemoConfiguration.timeout)
    }
}
