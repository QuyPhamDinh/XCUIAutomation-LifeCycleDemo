import XCTest
import XCUIAutomation

@MainActor
struct TabBar {
    let app: XCUIApplication

    func open(_ name: String, file: StaticString = #filePath, line: UInt = #line) {
        let tab = app.buttons[name]
        tab.tapWhenReady(message: "Missing tab: \(name)", file: file, line: line)
    }
}
