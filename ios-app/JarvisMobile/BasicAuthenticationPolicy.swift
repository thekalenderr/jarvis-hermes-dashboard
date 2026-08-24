import Foundation

enum BasicAuthenticationAction: Equatable {
    case useCredential
    case reject
    case defaultHandling
}

enum BasicAuthenticationPolicy {
    static func action(
        method: String,
        host: String,
        expectedHost: String?,
        previousFailures: Int
    ) -> BasicAuthenticationAction {
        guard method == NSURLAuthenticationMethodHTTPBasic,
              host.caseInsensitiveCompare(expectedHost ?? "") == .orderedSame else {
            return .defaultHandling
        }
        return previousFailures == 0 ? .useCredential : .reject
    }
}
