import XCTest
import XCUIAutomation

@MainActor
struct TabBar {
    let app: XCUIApplication

    func open(_ name: String) {
        let tab = app.buttons[name]
        XCTAssertTrue(tab.waitForExistence(timeout: DemoConfiguration.timeout), "Missing tab: \(name)")
        tab.tap()
    }
}
