import XCTest
import XCUIAutomation

@MainActor
struct LifecycleActions {
    let app: XCUIApplication

    func goHome() {
        XCUIDevice.shared.press(.home)
    }

    func resume() {
        app.activate()
    }

    func terminateAndRelaunch() {
        app.terminate()
        app.launch()
    }
}
