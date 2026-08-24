import Foundation

enum AuthenticatedRequestFactory {
    static func request(url: URL, username: String, password: String) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        let raw = "\(username):\(password)"
        let encoded = Data(raw.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("JarvisMobile/1.0.3", forHTTPHeaderField: "X-Jarvis-Client")
        return request
    }

    static func statusURL(from dashboardURL: URL) -> URL? {
        guard var components = URLComponents(url: dashboardURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.path = "/api/status"
        components.query = nil
        components.fragment = nil
        return components.url
    }
}
