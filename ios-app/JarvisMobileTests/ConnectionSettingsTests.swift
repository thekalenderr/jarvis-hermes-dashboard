import XCTest
@testable import JarvisMobile

final class ConnectionSettingsTests: XCTestCase {
    func testAcceptsSecureHTTPSDashboardURL() {
        XCTAssertTrue(ConnectionSettings.isValidDashboardURL("https://example.trycloudflare.com"))
    }

    func testRejectsPlainHTTPRemoteURL() {
        XCTAssertFalse(ConnectionSettings.isValidDashboardURL("http://example.com"))
    }

    func testNormalizesTrailingSlash() {
        XCTAssertEqual(
            ConnectionSettings.normalizedURL("https://example.com/path/"),
            URL(string: "https://example.com/path")
        )
    }
}
