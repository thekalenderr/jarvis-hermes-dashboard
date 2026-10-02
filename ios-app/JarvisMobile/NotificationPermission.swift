import Foundation
import UserNotifications

@MainActor
final class NotificationPermission: ObservableObject {
    @Published private(set) var statusText = "Bildirim izni henüz istenmedi."

    func request() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            statusText = granted
                ? "Bildirimler iPhone ayarlarından açık."
                : "Bildirim izni verilmedi. iPhone Ayarları'ndan açabilirsin."
        } catch {
            statusText = "Bildirim izni alınamadı: \(error.localizedDescription)"
        }
    }
}
