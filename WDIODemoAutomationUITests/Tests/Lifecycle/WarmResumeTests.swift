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
        forms.enter("Draft before switching")
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
        forms.enter("iOS draft")
        forms.setSwitch(true)

        let lifecycle = LifecycleActions(app: app)
        lifecycle.openAppSwitcher()
        lifecycle.resumeFromAppSwitcher()

        XCTAssertTrue(forms.screen.waitForExistence(timeout: DemoConfiguration.timeout))
        XCTAssertEqual(forms.inputValue, "iOS draft")
        XCTAssertTrue(forms.isOn)
    }
}
