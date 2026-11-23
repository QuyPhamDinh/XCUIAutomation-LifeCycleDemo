import XCTest
import XCUIAutomation

@MainActor
struct LoginScreen {
    let app: XCUIApplication

    private func element(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    func open() {
        TabBar(app: app).open("Login")
        XCTAssertTrue(element("Login-screen").waitForExistence(timeout: DemoConfiguration.timeout))
    }

    func submit(signup: Bool) {
        element(signup ? "button-sign-up-container" : "button-login-container").tap()
        let email = app.textFields["input-email"]
        let password = app.secureTextFields["input-password"]
        XCTAssertTrue(email.waitForExistence(timeout: DemoConfiguration.timeout))
        email.tap()
        email.typeText(DemoConfiguration.email)
        password.tap()
        password.typeText(DemoConfiguration.password)
        if signup {
            let repeatPassword = app.secureTextFields["input-repeat-password"]
            repeatPassword.tap()
            repeatPassword.typeText(DemoConfiguration.password)
        }
        element("Login-screen").tap()
        let submit = element(signup ? "button-SIGN UP" : "button-LOGIN")
        if !submit.isHittable {
            element("Login-screen").swipeUp()
        }
        submit.tap()
    }
}
