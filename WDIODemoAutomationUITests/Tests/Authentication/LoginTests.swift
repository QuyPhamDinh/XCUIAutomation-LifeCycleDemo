import XCTest
import XCUIAutomation

@MainActor
final class LoginTests: DemoUITestCase {
    func testSuccessfulLogin() {
        let login = LoginScreen(app: app)
        XCTAssertTrue(login.open(), "Login screen did not appear")
        login.login()
        let alert = AlertComponent(app: app)
        XCTAssertTrue(alert.waitForExistence(), "Expected alert did not appear")
        XCTAssertTrue(alert.title.contains("Success"), "Unexpected alert: \(alert.title)")
        alert.dismiss()
        XCTAssertTrue(alert.waitForDismissal(), "Alert did not dismiss")
    }
}
