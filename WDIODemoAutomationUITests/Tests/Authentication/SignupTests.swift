import XCTest
import XCUIAutomation

@MainActor
final class SignupTests: DemoUITestCase {
    func testSuccessfulSignup() {
        let login = LoginScreen(app: app)
        XCTAssertTrue(login.open(), "Login screen did not appear")
        XCTAssertTrue(
            login.signUp(email: DemoConfiguration.email, password: DemoConfiguration.password, confirm: DemoConfiguration.password),
            "Signup submission failed"
        )
        let alert = AlertComponent(app: app)
        XCTAssertTrue(alert.waitForExistence(), "Expected alert did not appear")
        XCTAssertTrue(alert.title.contains("Signed Up"), "Unexpected alert: \(alert.title)")
        XCTAssertTrue(alert.dismiss(), "Could not dismiss alert")
        XCTAssertTrue(alert.waitForDismissal(), "Alert did not dismiss")
    }
}
