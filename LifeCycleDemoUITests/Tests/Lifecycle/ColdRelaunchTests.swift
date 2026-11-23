import XCTest
import XCUIAutomation

@MainActor
final class ColdRelaunchTests: DemoUITestCase {
    func testFormsStateClearsAfterTermination() {
        let forms = FormsScreen(app: app)
        forms.open()
        forms.enter("Draft before kill")
        forms.setSwitch(true)

        LifecycleActions(app: app).terminateAndRelaunch()
        forms.open()

        XCTAssertTrue(forms.inputValue.isEmpty || forms.inputValue == "Type something")
        XCTAssertFalse(forms.isOn)
    }
}
