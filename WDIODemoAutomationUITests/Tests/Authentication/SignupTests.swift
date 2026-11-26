import XCTest
import XCUIAutomation

@MainActor
final class SignupTests: DemoUITestCase {
    func testSuccessfulSignup() {
        let login = LoginScreen(app: app)
        XCTAssertTrue(login.open(), "Login screen did not appear")
        login.signUp(email: DemoConfiguration.email, password: DemoConfiguration.password, confirm: DemoConfiguration.password)
        let alert = AlertComponent(app: app)
        XCTAssertTrue(alert.waitForExistence(), "Expected alert did not appear")
        XCTAssertTrue(alert.title.contains("Signed Up"), "Unexpected alert: \(alert.title)")
        alert.dismiss()
        XCTAssertTrue(alert.waitForDismissal(), "Alert did not dismiss")
    }
}
