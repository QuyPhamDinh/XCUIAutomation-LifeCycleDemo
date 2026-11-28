import XCTest
import XCUIAutomation

@MainActor
struct FormsScreen {
    private enum Identifier {
        static let screen = "Forms-screen"
        static let textInput = "text-input"
        static let toggle = "switch"
    }

    let app: XCUIApplication

    var screen: XCUIElement { app.descendants(matching: .any)[Identifier.screen] }
    var input: XCUIElement { app.textFields[Identifier.textInput] }
    var toggle: XCUIElement { app.switches[Identifier.toggle] }

    func open(file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard TabBar(app: app).open(.forms, file: file, line: line) else { return false }
        return screen.waitForExistence(timeout: DemoConfiguration.timeout)
    }

    @discardableResult
    func enter(_ text: String, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard input.tapWhenReady(file: file, line: line) else { return false }
        input.typeText(text)
        return true
    }

    @discardableResult
    func fillDraft(_ text: String, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard input.typeTextWithPacing(text, file: file, line: line) else { return false }
        return setSwitch(true, file: file, line: line)
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

    @discardableResult
    func setSwitch(_ on: Bool, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        guard toggle.waitForHittable(timeout: DemoConfiguration.timeout) else {
            XCTFail("Switch did not become hittable", file: file, line: line)
            return false
        }
        if isOn != on {
            toggle.tap()
        }
        return isOn == on
    }
}
