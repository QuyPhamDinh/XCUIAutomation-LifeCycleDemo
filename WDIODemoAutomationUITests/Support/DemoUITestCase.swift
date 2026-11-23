import XCTest
import XCUIAutomation

@MainActor
class DemoUITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication(bundleIdentifier: DemoConfiguration.bundleIdentifier)
        app.launch()
        XCTAssertTrue(app.buttons["Home"].waitForExistence(timeout: DemoConfiguration.timeout),
                      "The WDIO demo app did not show its tab bar. Install its iOS simulator build first.")
    }

    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }

    override func record(_ issue: XCTIssue) {
        if issue.type == .assertionFailure || issue.type == .uncaughtException {
            let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            screenshot.name = "Failure screenshot"
            screenshot.lifetime = .keepAlways
            add(screenshot)
            if let app {
                let hierarchy = XCTAttachment(string: app.debugDescription)
                hierarchy.name = "Application hierarchy"
                hierarchy.lifetime = .keepAlways
                add(hierarchy)
            }
        }
        super.record(issue)
    }
}
