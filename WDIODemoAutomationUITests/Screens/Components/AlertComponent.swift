import XCTest
import XCUIAutomation

@MainActor
struct AlertComponent {
    let app: XCUIApplication

    func assertAndDismissAlert(title: String, file: StaticString = #filePath, line: UInt = #line) {
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: DemoConfiguration.timeout), file: file, line: line)
        XCTAssertTrue(alert.label.contains(title), "Expected alert containing: \(title); got: \(alert.label)", file: file, line: line)
        alert.buttons["OK"].tap()
        XCTAssertTrue(alert.waitForNonExistence(timeout: DemoConfiguration.timeout), file: file, line: line)
    }
}
