import XCTest
import XCUIAutomation

@MainActor
enum DemoConfiguration {
    static let bundleIdentifier = "org.wdiodemoapp"
    static let timeout: TimeInterval = 15
    static let email = "test@webdriver.io"
    static let password = "Test1234!"
}
