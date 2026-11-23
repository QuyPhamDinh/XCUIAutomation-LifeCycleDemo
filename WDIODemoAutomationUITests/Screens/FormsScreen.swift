import XCTest
import XCUIAutomation

@MainActor
struct FormsScreen {
    let app: XCUIApplication

    var screen: XCUIElement { app.descendants(matching: .any)["Forms-screen"] }
    var input: XCUIElement { app.textFields["text-input"] }
    var toggle: XCUIElement { app.switches["switch"] }

    func open() {
        TabBar(app: app).open("Forms")
        XCTAssertTrue(screen.waitForExistence(timeout: DemoConfiguration.timeout), "Forms screen did not appear")
    }

    func enter(_ text: String) {
        XCTAssertTrue(input.waitForExistence(timeout: DemoConfiguration.timeout))
        input.tap()
        input.typeText(text)
    }

    var inputValue: String {
        input.value as? String ?? ""
    }

    var isInputEmpty: Bool {
        let value = inputValue
        return value.isEmpty || value == "Type something"
    }

    var isOn: Bool {
        (toggle.value as? String) == "1"
    }

    func setSwitch(_ on: Bool) {
        XCTAssertTrue(toggle.waitForExistence(timeout: DemoConfiguration.timeout))
        if isOn != on {
            toggle.tap()
        }
        XCTAssertEqual(isOn, on)
    }
}
