import XCTest
import XCUIAutomation

@MainActor
extension XCUIElement {
    @discardableResult
    func tapWhenReady(
        timeout: TimeInterval = DemoConfiguration.timeout,
        message: String = "Element did not appear",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard waitForExistence(timeout: timeout) else {
            XCTFail(message, file: file, line: line)
            return false
        }
        tap()
        return true
    }
}
