import XCTest
import XCUIAutomation

@MainActor
final class LoginTests: DemoUITestCase {
    func testSuccessfulLogin() {
        let login = LoginScreen(app: app)
        XCTAssertTrue(login.open(), "Login screen did not appear")
        XCTAssertTrue(login.login(), "Login submission failed")
        let alert = AlertComponent(app: app)
        XCTAssertTrue(alert.waitForExistence(), "Expected alert did not appear")
        XCTAssertTrue(alert.title.contains("Success"), "Unexpected alert: \(alert.title)")
        XCTAssertTrue(alert.dismiss(), "Could not dismiss alert")
        XCTAssertTrue(alert.waitForDismissal(), "Alert did not dismiss")
    }
}
