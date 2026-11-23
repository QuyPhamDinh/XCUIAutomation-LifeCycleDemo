import XCTest
import XCUIAutomation

@MainActor
class DemoUITestCase: XCTestCase {
    var app: XCUIApplication!

    var bundleIdentifier: String { DemoConfiguration.bundleIdentifier }
    var readyElement: XCUIElement { app.buttons["Home"] }
    var readinessFailureMessage: String { "The app did not become ready after launch." }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication(bundleIdentifier: bundleIdentifier)
        app.launch()
        XCTAssertTrue(readyElement.waitForExistence(timeout: DemoConfiguration.timeout),
                      readinessFailureMessage)
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
