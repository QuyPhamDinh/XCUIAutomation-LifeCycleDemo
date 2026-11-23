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

    private func inspectSecureField(
        _ field: XCUIElement, name: String, stage: String, expectedCount: Int,
        file: StaticString, line: UInt
    ) {
        guard let value = field.value as? String,
              value.allSatisfy({ "•●*".contains($0) }) else {
            print("\(stage): \(name) masked character count unavailable")
            return
        }

        print("\(stage): \(name) has \(value.count) masked characters")
        XCTAssertEqual(value.count, expectedCount, "\(stage): unexpected \(name) character count", file: file, line: line)
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
            inspectSecureField(password, name: "password", stage: "After password entry",
                               expectedCount: DemoConfiguration.password.count, file: file, line: line)
            inspectSecureField(repeatPassword, name: "confirmation", stage: "After password entry",
                               expectedCount: 0, file: file, line: line)
            repeatPassword.tap()
            repeatPassword.typeText(DemoConfiguration.password)
            inspectSecureField(password, name: "password", stage: "After confirmation entry",
                               expectedCount: DemoConfiguration.password.count, file: file, line: line)
            inspectSecureField(repeatPassword, name: "confirmation", stage: "After confirmation entry",
                               expectedCount: DemoConfiguration.password.count, file: file, line: line)
        }
        element(Identifier.screen).tap()
        let submit = element(signup ? Identifier.signupButton : Identifier.loginButton)
        if !submit.isHittable {
            element(Identifier.screen).swipeUp()
        }
        submit.tap()
    }
}
