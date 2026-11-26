import XCTest
import XCUIAutomation

@MainActor
final class ColdRelaunchTests: DemoUITestCase {
    func testFormsStateClearsAfterTermination() {
        let forms = FormsScreen(app: app)
        XCTAssertTrue(forms.open(), "Forms screen did not appear")
        forms.enter("Draft before kill")
        XCTAssertTrue(forms.setSwitch(true), "Could not turn switch on")

        LifecycleActions(app: app).terminateAndRelaunch()
        XCTAssertTrue(forms.open(), "Forms screen did not appear")

        XCTAssertTrue(forms.isInputEmpty, "Form input should be empty after termination and relaunch")
        XCTAssertFalse(forms.isOn, "Form switch should be off after termination and relaunch")
    }
}
