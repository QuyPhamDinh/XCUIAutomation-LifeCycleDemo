import XCTest
import XCUIAutomation

@MainActor
extension XCUIElement {
    /// Paces input into an empty, non-secure text field by verifying each prefix.
    @discardableResult
    func typeTextWithPacing(
        _ text: String,
        timeoutPerCharacter: TimeInterval = 2,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        guard tapWhenReady(file: file, line: line) else { return false }

        var expected = ""
        for character in text {
            expected.append(character)
            typeText(String(character))
            let prefix = XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "value == %@", expected),
                object: self
            )
            guard XCTWaiter.wait(for: [prefix], timeout: timeoutPerCharacter) == .completed else {
                let actual = value as? String ?? "<nil>"
                XCTFail("After typing [\(character)], expected [\(expected)], got [\(actual)]", file: file, line: line)
                return false
            }
        }
        return true
    }
}
