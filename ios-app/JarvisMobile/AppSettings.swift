import Foundation

@MainActor
final class AppSettings: ObservableObject {
    @Published var dashboardURL: String
    @Published var username: String
    @Published var password: String
    @Published var errorMessage: String?

    private let defaults = UserDefaults.standard
    private let urlKey = "jarvis.dashboard.url"
    private let userKey = "jarvis.dashboard.user"
    private let passwordAccount = "dashboard-basic-auth"

    init() {
        dashboardURL = defaults.string(forKey: urlKey)
            ?? "https://jarvis.50-6-36-201.sslip.io"
        username = defaults.string(forKey: userKey) ?? "jarvis"
        password = KeychainStore.get(account: passwordAccount)
    }

    var url: URL? { ConnectionSettings.normalizedURL(dashboardURL) }
    var hasConfiguration: Bool { url != nil && !username.isEmpty && !password.isEmpty }

    @discardableResult
    func save() -> Bool {
        guard let normalized = url else {
            errorMessage = "Geçerli bir HTTPS Jarvis bağlantısı yaz."
            return false
        }
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Kullanıcı adı ve parola gerekli."
            return false
        }
        do {
            try KeychainStore.set(password, account: passwordAccount)
            dashboardURL = normalized.absoluteString
            username = username.trimmingCharacters(in: .whitespaces)
            defaults.set(dashboardURL, forKey: urlKey)
            defaults.set(username, forKey: userKey)
            errorMessage = nil
            return true
        } catch {
            errorMessage = "Parola iPhone Keychain'e kaydedilemedi."
            return false
        }
    }

    func reset() {
        defaults.removeObject(forKey: urlKey)
        defaults.removeObject(forKey: userKey)
        KeychainStore.delete(account: passwordAccount)
        dashboardURL = ""
        username = "jarvis"
        password = ""
        errorMessage = nil
    }
}
