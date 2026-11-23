import XCTest
import XCUIAutomation

@MainActor
final class SignupTests: DemoUITestCase {
    func testSuccessfulSignup() {
        let login = LoginScreen(app: app)
        login.open()
        login.submit(signup: true)
        AlertComponent(app: app).assertAndDismissAlert(title: "Signed Up")
    }
}
