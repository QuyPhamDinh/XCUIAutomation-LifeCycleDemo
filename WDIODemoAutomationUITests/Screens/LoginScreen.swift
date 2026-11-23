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

    func open(file: StaticString = #filePath, line: UInt = #line) {
        TabBar(app: app).open("Login", file: file, line: line)
        XCTAssertTrue(element(Identifier.screen).waitForExistence(timeout: DemoConfiguration.timeout), file: file, line: line)
    }

    func submit(signup: Bool, file: StaticString = #filePath, line: UInt = #line) {
        element(signup ? Identifier.signupContainer : Identifier.loginContainer).tap()
        let email = app.textFields[Identifier.email]
        let password = app.secureTextFields[Identifier.password]
        guard email.tapWhenReady(file: file, line: line) else { return }
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
