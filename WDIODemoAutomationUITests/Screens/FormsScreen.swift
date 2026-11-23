import XCTest
import XCUIAutomation

@MainActor
struct FormsScreen {
    let app: XCUIApplication

    var screen: XCUIElement { app.descendants(matching: .any)["Forms-screen"] }
    var input: XCUIElement { app.textFields["text-input"] }
    var toggle: XCUIElement { app.switches["switch"] }

    func open(file: StaticString = #filePath, line: UInt = #line) {
        TabBar(app: app).open("Forms", file: file, line: line)
        XCTAssertTrue(screen.waitForExistence(timeout: DemoConfiguration.timeout), "Forms screen did not appear", file: file, line: line)
    }

    func enter(_ text: String, file: StaticString = #filePath, line: UInt = #line) {
        guard input.tapWhenReady(file: file, line: line) else { return }
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

    func setSwitch(_ on: Bool, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(toggle.waitForExistence(timeout: DemoConfiguration.timeout), file: file, line: line)
        if isOn != on {
            toggle.tap()
        }
        XCTAssertEqual(isOn, on, file: file, line: line)
    }
}
