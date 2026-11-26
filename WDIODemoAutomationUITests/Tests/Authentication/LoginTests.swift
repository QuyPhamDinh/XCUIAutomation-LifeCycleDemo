import XCTest
import XCUIAutomation

@MainActor
final class LoginTests: DemoUITestCase {
    func testSuccessfulLogin() {
        let login = LoginScreen(app: app)
        login.open()
        login.login()
        AlertComponent(app: app).assertAndDismissAlert(title: "Success")
    }
}
