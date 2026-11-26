import XCTest
import XCUIAutomation

@MainActor
final class SignupTests: DemoUITestCase {
    func testSuccessfulSignup() {
        let login = LoginScreen(app: app)
        login.open()
        login.signUp(email: DemoConfiguration.email, password: DemoConfiguration.password, confirm: DemoConfiguration.password)
        AlertComponent(app: app).assertAndDismissAlert(title: "Signed Up")
    }
}
