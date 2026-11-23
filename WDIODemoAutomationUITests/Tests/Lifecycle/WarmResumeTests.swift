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
        XCTAssertEqual(forms.inputValue, "Draft before switching", "Text did not match immediately after typing")
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
        var expected = ""
        let input = forms.input
        guard input.tapWhenReady() else { return }
        for character in draft {
            expected.append(character)
            input.typeText(String(character))
            let prefix = XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "value == %@", expected),
                object: input
            )
            guard XCTWaiter.wait(for: [prefix], timeout: 2) == .completed else {
                let actual = input.value as? String ?? "<nil>"
                XCTFail("After typing [\(character)], expected [\(expected)], got [\(actual)]")
                return
            }
        }
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
