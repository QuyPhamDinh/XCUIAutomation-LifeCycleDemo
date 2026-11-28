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

    func open(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard TabBar(app: app).open(.login, file: file, line: line) else { return false }
        return element(Identifier.screen).waitForExistence(timeout: DemoConfiguration.timeout)
    }

    @discardableResult
    func login(
        email: String? = nil,
        password: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard element(Identifier.loginContainer).tapWhenReady(file: file, line: line) else { return false }
        guard enterCredentials(email: email ?? DemoConfiguration.email,
                               password: password ?? DemoConfiguration.password,
                               file: file, line: line) else { return false }
        return element(Identifier.loginButton).scrollToAndTap(
            in: element(Identifier.screen),
            message: "Submit button was not reachable: \(Identifier.loginButton)",
            file: file,
            line: line
        )
    }

    @discardableResult
    func signUp(
        email: String,
        password: String,
        confirm: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard element(Identifier.signupContainer).tapWhenReady(file: file, line: line) else { return false }
        guard enterCredentials(email: email, password: password, file: file, line: line) else { return false }
        let repeatPassword = app.secureTextFields[Identifier.repeatPassword]
        guard repeatPassword.tapWhenReady(file: file, line: line) else { return false }
        if !confirm.isEmpty {
            repeatPassword.typeText(confirm)
        }
        return element(Identifier.signupButton).scrollToAndTap(
            in: element(Identifier.screen),
            message: "Submit button was not reachable: \(Identifier.signupButton)",
            file: file,
            line: line
        )
    }

    private func enterCredentials(email: String, password: String, file: StaticString, line: UInt) -> Bool {
        let emailField = app.textFields[Identifier.email]
        let passwordField = app.secureTextFields[Identifier.password]
        guard emailField.tapWhenReady(file: file, line: line) else { return false }
        if !email.isEmpty {
            emailField.typeText(email)
        }
        guard passwordField.tapWhenReady(file: file, line: line) else { return false }
        if !password.isEmpty {
            passwordField.typeText(password)
        }
        return true
    }
}
