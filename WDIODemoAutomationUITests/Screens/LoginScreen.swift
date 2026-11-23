import XCTest
import XCUIAutomation

@MainActor
struct LoginScreen {
    private enum Identifier {
        static let screen = "Login-screen"
        static let loginContainer = "button-login-container"
        static let signupContainer = "button-sign-up-container"
        static let email = "input-email"
        static let password = "input-password"
        static let repeatPassword = "input-repeat-password"
        static let loginButton = "button-LOGIN"
        static let signupButton = "button-SIGN UP"
    }

    let app: XCUIApplication

    private func element(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    func open() {
        TabBar(app: app).open("Login")
        XCTAssertTrue(element(Identifier.screen).waitForExistence(timeout: DemoConfiguration.timeout))
    }

    func submit(signup: Bool) {
        element(signup ? Identifier.signupContainer : Identifier.loginContainer).tap()
        let email = app.textFields[Identifier.email]
        let password = app.secureTextFields[Identifier.password]
        XCTAssertTrue(email.waitForExistence(timeout: DemoConfiguration.timeout))
        email.tap()
        email.typeText(DemoConfiguration.email)
        password.tap()
        password.typeText(DemoConfiguration.password)
        if signup {
            let repeatPassword = app.secureTextFields[Identifier.repeatPassword]
            repeatPassword.tap()
            repeatPassword.typeText(DemoConfiguration.password)
        }
        element(Identifier.screen).tap()
        let submit = element(signup ? Identifier.signupButton : Identifier.loginButton)
        if !submit.isHittable {
            element(Identifier.screen).swipeUp()
        }
        submit.tap()
    }
}
