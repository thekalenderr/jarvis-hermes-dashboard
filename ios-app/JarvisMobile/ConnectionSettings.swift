import Foundation

enum ConnectionSettings {
    static let stableDashboardURL = "https://jarvis.50-6-36-201.sslip.io"

    static func migratedDashboardURL(_ raw: String) -> String {
        guard let host = URL(string: raw)?.host?.lowercased(),
              host.hasSuffix(".trycloudflare.com") else {
            return raw
        }
        return stableDashboardURL
    }

    static func normalizedURL(_ raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard var components = URLComponents(string: trimmed),
              components.scheme?.lowercased() == "https",
              components.host?.isEmpty == false else {
            return nil
        }
        if components.path.count > 1, components.path.hasSuffix("/") {
            components.path.removeLast()
        }
        return components.url
    }

    static func isValidDashboardURL(_ raw: String) -> Bool {
        normalizedURL(raw) != nil
    }
}
