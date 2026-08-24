import XCTest
@testable import JarvisMobile

final class AuthenticatedRequestFactoryTests: XCTestCase {
    func testAddsBasicAuthorizationHeader() throws {
        let request = AuthenticatedRequestFactory.request(
            url: try XCTUnwrap(URL(string: "https://panel.example.com")),
            username: "jarvis",
            password: "secret"
        )
        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Authorization"),
            "Basic amFydmlzOnNlY3JldA=="
        )
    }

    func testBuildsStatusEndpointWithoutKeepingOldPath() throws {
        XCTAssertEqual(
            AuthenticatedRequestFactory.statusURL(
                from: try XCTUnwrap(URL(string: "https://panel.example.com/old/"))
            ),
            URL(string: "https://panel.example.com/api/status")
        )
    }
}
