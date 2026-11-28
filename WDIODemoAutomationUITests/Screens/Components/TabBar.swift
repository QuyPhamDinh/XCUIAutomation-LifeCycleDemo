import XCTest
import XCUIAutomation

enum AppTab: String {
    case home = "Home"
    case login = "Login"
    case forms = "Forms"
}

@MainActor
struct TabBar {
    let app: XCUIApplication

    func element(for tab: AppTab) -> XCUIElement {
        app.buttons[tab.rawValue]
    }

    @discardableResult
    func open(_ tab: AppTab, file: StaticString = #filePath, line: UInt = #line) -> Bool {
        element(for: tab).tapWhenReady(message: "Missing tab: \(tab.rawValue)", file: file, line: line)
    }
}
