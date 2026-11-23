import XCTest
import XCUIAutomation

@MainActor
final class WarmResumeTests: DemoUITestCase {
    func testFormsStateSurvivesHomeAndResume() {
        let forms = FormsScreen(app: app)
        let lifecycle = LifecycleActions(app: app)
        forms.open()
        XCTAssertTrue(forms.isInputEmpty)
        forms.setSwitch(false)
        let draft = "Draft before switching"
        guard forms.input.typeTextVerifyingEachCharacter(draft) else { return }
        XCTAssertEqual(forms.inputValue, draft, "Text did not match immediately after typing")
        forms.setSwitch(true)

        lifecycle.sendToBackground()
        lifecycle.resume()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "Draft before switching")
        XCTAssertTrue(forms.isOn)
        forms.setSwitch(false)
    }

    func testFormsStateSurvivesAppSwitcher() {
        let forms = FormsScreen(app: app)
        forms.open()
        let draft = "iOS draft"
        guard forms.input.typeTextVerifyingEachCharacter(draft) else { return }
        XCTAssertEqual(forms.inputValue, draft, "Text did not match immediately after typing")
        forms.setSwitch(true)

        let lifecycle = LifecycleActions(app: app)
        lifecycle.openAppSwitcher()
        lifecycle.resumeFromAppSwitcher()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "iOS draft")
        XCTAssertTrue(forms.isOn)
    }
}
