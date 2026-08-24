import XCTest
@testable import JarvisMobile

final class BasicAuthenticationPolicyTests: XCTestCase {
    func testFirstBasicChallengeUsesCredential() {
        XCTAssertEqual(
            BasicAuthenticationPolicy.action(
                method: NSURLAuthenticationMethodHTTPBasic,
                host: "jarvis.50-6-36-201.sslip.io",
                expectedHost: "jarvis.50-6-36-201.sslip.io",
                previousFailures: 0
            ),
            .useCredential
        )
    }

    func testRepeatedBasicChallengeRejectsInsteadOfLoopingOnBlackScreen() {
        XCTAssertEqual(
            BasicAuthenticationPolicy.action(
                method: NSURLAuthenticationMethodHTTPBasic,
                host: "jarvis.50-6-36-201.sslip.io",
                expectedHost: "jarvis.50-6-36-201.sslip.io",
                previousFailures: 1
            ),
            .reject
        )
    }

    func testUnrelatedChallengeUsesDefaultHandling() {
        XCTAssertEqual(
            BasicAuthenticationPolicy.action(
                method: NSURLAuthenticationMethodServerTrust,
                host: "jarvis.50-6-36-201.sslip.io",
                expectedHost: "jarvis.50-6-36-201.sslip.io",
                previousFailures: 0
            ),
            .defaultHandling
        )
    }
}
