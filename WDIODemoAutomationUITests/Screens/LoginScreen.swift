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

    func login(
        email: String? = nil,
        password: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        element(Identifier.loginContainer).tap()
        guard enterCredentials(email: email ?? DemoConfiguration.email,
                               password: password ?? DemoConfiguration.password,
                               file: file, line: line) else { return }
        submitButton(Identifier.loginButton)
    }

    func signUp(
        email: String,
        password: String,
        confirm: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        element(Identifier.signupContainer).tap()
        guard enterCredentials(email: email, password: password, file: file, line: line) else { return }
        let repeatPassword = app.secureTextFields[Identifier.repeatPassword]
        repeatPassword.tap()
        if !confirm.isEmpty {
            repeatPassword.typeText(confirm)
        }
        submitButton(Identifier.signupButton)
    }

    private func enterCredentials(email: String, password: String, file: StaticString, line: UInt) -> Bool {
        let emailField = app.textFields[Identifier.email]
        let passwordField = app.secureTextFields[Identifier.password]
        guard emailField.tapWhenReady(file: file, line: line) else { return false }
        if !email.isEmpty {
            emailField.typeText(email)
        }
        passwordField.tap()
        if !password.isEmpty {
            passwordField.typeText(password)
        }
        return true
    }

    private func submitButton(_ identifier: String) {
        element(Identifier.screen).tap()
        let submit = element(identifier)
        if !submit.isHittable {
            element(Identifier.screen).swipeUp()
        }
        submit.tap()
    }
}
