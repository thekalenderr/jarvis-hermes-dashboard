import XCTest
@testable import JarvisMobile

final class LiveConnectionTests: XCTestCase {
    func testStableEndpointAcceptsCurrentMobileCredentials() async throws {
        XCTAssertFalse(UnitTestSecrets.password.isEmpty, "CI must generate UnitTestSecrets.password")
        let base = try XCTUnwrap(URL(string: ConnectionSettings.stableDashboardURL))
        let statusURL = try XCTUnwrap(AuthenticatedRequestFactory.statusURL(from: base))
        let request = AuthenticatedRequestFactory.request(
            url: statusURL,
            username: "jarvis",
            password: UnitTestSecrets.password
        )
        let (_, response) = try await URLSession.shared.data(for: request)
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
    }
}
