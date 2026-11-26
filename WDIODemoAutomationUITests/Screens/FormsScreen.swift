import XCTest
import XCUIAutomation

@MainActor
struct FormsScreen {
    let app: XCUIApplication

    var screen: XCUIElement { app.descendants(matching: .any)["Forms-screen"] }
    var input: XCUIElement { app.textFields["text-input"] }
    var toggle: XCUIElement { app.switches["switch"] }

    func open(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        TabBar(app: app).open("Forms", file: file, line: line)
        return screen.waitForExistence(timeout: DemoConfiguration.timeout)
    }

    func enter(_ text: String, file: StaticString = #filePath, line: UInt = #line) {
        guard input.tapWhenReady(file: file, line: line) else { return }
        input.typeText(text)
    }

    func fillDraft(_ text: String, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard input.typeTextWithPacing(text, file: file, line: line) else { return false }
        return setSwitch(true)
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

    func setSwitch(_ on: Bool) -> Bool {
        guard toggle.waitForExistence(timeout: DemoConfiguration.timeout) else { return false }
        if isOn != on {
            toggle.tap()
        }
        return isOn == on
    }
}
