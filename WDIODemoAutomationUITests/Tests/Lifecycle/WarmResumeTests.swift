import XCTest
import XCUIAutomation

@MainActor
final class WarmResumeTests: DemoUITestCase {
    func testFormsStateSurvivesHomeAndResume() {
        let forms = FormsScreen(app: app)
        let lifecycle = LifecycleActions(app: app)
        XCTAssertTrue(forms.open(), "Forms screen did not appear")
        XCTAssertTrue(forms.isInputEmpty)
        XCTAssertTrue(forms.setSwitch(false), "Could not turn switch off")
        let draft = "Draft before switching"
        XCTAssertTrue(forms.fillDraft(draft), "Could not prepare form draft")

        XCTAssertTrue(lifecycle.sendToBackground(), "App did not enter background")
        lifecycle.resume()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "Draft before switching")
        XCTAssertTrue(forms.isOn)
    }

    func testFormsStateSurvivesAppSwitcher() {
        let forms = FormsScreen(app: app)
        XCTAssertTrue(forms.open(), "Forms screen did not appear")
        let draft = "iOS draft"
        XCTAssertTrue(forms.fillDraft(draft), "Could not prepare form draft")

        let lifecycle = LifecycleActions(app: app)
        lifecycle.openAppSwitcher()
        XCTAssertTrue(lifecycle.resumeFromAppSwitcher(), "Could not resume from App Switcher")

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "iOS draft")
        XCTAssertTrue(forms.isOn)
    }
}
