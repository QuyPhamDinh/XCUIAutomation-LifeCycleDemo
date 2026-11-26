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
        TabBar(app: app).open("Login", file: file, line: line)
        return element(Identifier.screen).waitForExistence(timeout: DemoConfiguration.timeout)
    }

    func login(
        email: String? = nil,
        password: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard element(Identifier.loginContainer).tapWhenReady(file: file, line: line) else { return }
        guard enterCredentials(email: email ?? DemoConfiguration.email,
                               password: password ?? DemoConfiguration.password,
                               file: file, line: line) else { return }
        submitButton(Identifier.loginButton, file: file, line: line)
    }

    func signUp(
        email: String,
        password: String,
        confirm: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard element(Identifier.signupContainer).tapWhenReady(file: file, line: line) else { return }
        guard enterCredentials(email: email, password: password, file: file, line: line) else { return }
        let repeatPassword = app.secureTextFields[Identifier.repeatPassword]
        guard repeatPassword.tapWhenReady(file: file, line: line) else { return }
        if !confirm.isEmpty {
            repeatPassword.typeText(confirm)
        }
        submitButton(Identifier.signupButton, file: file, line: line)
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

    private func submitButton(_ identifier: String, file: StaticString, line: UInt) {
        let submit = element(identifier)
        guard submit.waitForExistence(timeout: DemoConfiguration.timeout) else {
            XCTFail("Submit button did not appear: \(identifier)", file: file, line: line)
            return
        }

        for _ in 0..<4 {
            if submit.isHittable {
                submit.tap()
                return
            }
            element(Identifier.screen).swipeUp()
        }

        guard submit.isHittable else {
            XCTFail("Submit button was not reachable: \(identifier)", file: file, line: line)
            return
        }
        submit.tap()
    }
}
