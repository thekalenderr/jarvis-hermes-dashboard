import Foundation

enum ConnectionVerificationResult: Equatable {
    case authorized
    case unauthorized
    case httpError(Int)
}

enum ConnectionVerifier {
    static func verify(
        dashboardURL: URL,
        username: String,
        password: String,
        session: URLSession = .shared
    ) async throws -> ConnectionVerificationResult {
        guard let statusURL = AuthenticatedRequestFactory.statusURL(from: dashboardURL) else {
            return .httpError(0)
        }
        let request = AuthenticatedRequestFactory.request(
            url: statusURL,
            username: username,
            password: password
        )
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { return .httpError(0) }
        switch http.statusCode {
        case 200: return .authorized
        case 401: return .unauthorized
        default: return .httpError(http.statusCode)
        }
    }
}
