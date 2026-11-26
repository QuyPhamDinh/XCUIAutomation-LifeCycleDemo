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
        guard forms.input.typeTextVerifyingEachCharacter(draft) else { return }
        XCTAssertEqual(forms.inputValue, draft, "Text did not match immediately after typing")
        XCTAssertTrue(forms.setSwitch(true), "Could not turn switch on")

        lifecycle.sendToBackground()
        lifecycle.resume()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "Draft before switching")
        XCTAssertTrue(forms.isOn)
        XCTAssertTrue(forms.setSwitch(false), "Could not turn switch off")
    }

    func testFormsStateSurvivesAppSwitcher() {
        let forms = FormsScreen(app: app)
        XCTAssertTrue(forms.open(), "Forms screen did not appear")
        let draft = "iOS draft"
        guard forms.input.typeTextVerifyingEachCharacter(draft) else { return }
        XCTAssertEqual(forms.inputValue, draft, "Text did not match immediately after typing")
        XCTAssertTrue(forms.setSwitch(true), "Could not turn switch on")

        let lifecycle = LifecycleActions(app: app)
        lifecycle.openAppSwitcher()
        lifecycle.resumeFromAppSwitcher()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "iOS draft")
        XCTAssertTrue(forms.isOn)
    }
}
