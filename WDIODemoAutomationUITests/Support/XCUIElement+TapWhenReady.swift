import XCTest
import XCUIAutomation

@MainActor
extension XCUIElement {
    /// Waits until the element exists and is hittable within `timeout`.
    func waitForHittable(timeout: TimeInterval = DemoConfiguration.timeout) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        guard waitForExistence(timeout: timeout) else { return false }
        if isHittable { return true }

        let remaining = deadline.timeIntervalSinceNow
        guard remaining > 0 else { return false }

        let hittable = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in
                self.exists && self.isHittable
            },
            object: nil
        )
        return XCTWaiter.wait(for: [hittable], timeout: remaining) == .completed
    }

    @discardableResult
    func tapWhenReady(
        timeout: TimeInterval = DemoConfiguration.timeout,
        message: String = "Element did not become hittable",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard waitForHittable(timeout: timeout) else {
            XCTFail(message, file: file, line: line)
            return false
        }
        tap()
        return true
    }

    /// Waits for the element to appear, scrolls `container` upward until it is hittable, then taps it.
    @discardableResult
    func scrollToAndTap(
        in container: XCUIElement,
        maxSwipes: Int = 4,
        timeout: TimeInterval = DemoConfiguration.timeout,
        message: String = "Element was not reachable",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard waitForExistence(timeout: timeout) else {
            XCTFail(message, file: file, line: line)
            return false
        }

        for _ in 0..<maxSwipes {
            if isHittable {
                tap()
                return true
            }
            container.swipeUp()
        }

        return tapWhenReady(timeout: 1, message: message, file: file, line: line)
    }
}
