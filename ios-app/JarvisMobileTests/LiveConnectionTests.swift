import XCTest
@testable import JarvisMobile

final class LiveConnectionTests: XCTestCase {
    func testStableEndpointAcceptsCurrentMobileCredentials() async throws {
        XCTAssertFalse(UnitTestSecrets.password.isEmpty, "CI must generate UnitTestSecrets.password")
        let result = try await ConnectionVerifier.verify(
            dashboardURL: try XCTUnwrap(URL(string: ConnectionSettings.stableDashboardURL)),
            username: "jarvis",
            password: UnitTestSecrets.password
        )
        XCTAssertEqual(result, .authorized)
    }

    func testStableEndpointRejectsWrongPasswordWithoutHanging() async throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpShouldSetCookies = false
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let result = try await ConnectionVerifier.verify(
            dashboardURL: try XCTUnwrap(URL(string: ConnectionSettings.stableDashboardURL)),
            username: "jarvis",
            password: "yanlis-parola",
            session: session
        )
        XCTAssertEqual(result, .unauthorized)
    }
}
