import XCTest
import XCUIAutomation

enum AlertButton: String {
    case ok = "OK"
}

@MainActor
struct AlertComponent {
    let app: XCUIApplication

    var alert: XCUIElement { app.alerts.firstMatch }
    var title: String { alert.label }

    func waitForExistence(timeout: TimeInterval = DemoConfiguration.timeout) -> Bool {
        alert.waitForExistence(timeout: timeout)
    }

    @discardableResult
    func dismiss(
        button: AlertButton = .ok,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        alert.buttons[button.rawValue].tapWhenReady(
            message: "Missing alert button: \(button.rawValue)",
            file: file,
            line: line
        )
    }

    func waitForDismissal(timeout: TimeInterval = DemoConfiguration.timeout) -> Bool {
        alert.waitForNonExistence(timeout: timeout)
    }
}
