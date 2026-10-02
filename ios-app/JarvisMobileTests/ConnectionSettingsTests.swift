import XCTest
@testable import JarvisMobile

final class ConnectionSettingsTests: XCTestCase {
    func testAcceptsSecureHTTPSDashboardURL() {
        XCTAssertTrue(ConnectionSettings.isValidDashboardURL("https://example.trycloudflare.com"))
    }

    func testRejectsPlainHTTPRemoteURL() {
        XCTAssertFalse(ConnectionSettings.isValidDashboardURL("http://example.com"))
    }

    func testMigratesLegacyEndpointToStableDomain() {
        XCTAssertEqual(
            ConnectionSettings.migratedDashboardURL("https://jarvis.50-6-36-201.sslip.io"),
            "https://jarvis.umitkalender.com"
        )
    }

    func testMigratesLegacyQuickTunnelToStableEndpoint() {
        XCTAssertEqual(
            ConnectionSettings.migratedDashboardURL("https://old-link.trycloudflare.com"),
            "https://jarvis.umitkalender.com"
        )
    }

    func testPreservesNonLegacySecureEndpoint() {
        XCTAssertEqual(
            ConnectionSettings.migratedDashboardURL("https://panel.example.com"),
            "https://panel.example.com"
        )
    }

    func testNormalizesTrailingSlash() {
        XCTAssertEqual(
            ConnectionSettings.normalizedURL("https://example.com/path/"),
            URL(string: "https://example.com/path")
        )
    }
}
