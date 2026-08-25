import SwiftUI

struct DashboardView: View {
    @ObservedObject var settings: AppSettings
    let onSettings: () -> Void
    @State private var loading = true
    @State private var authorized = false
    @State private var error: String?
    @State private var reloadToken = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            if authorized, let url = settings.url {
                JarvisWebView(
                    url: url,
                    username: settings.username,
                    password: settings.password,
                    isLoading: $loading,
                    errorMessage: $error,
                    reloadToken: reloadToken
                )
                .ignoresSafeArea()
            }

            HStack(spacing: 9) {
                if loading { ProgressView().tint(.cyan).padding(9) }
                Button {
                    authorized = false
                    reloadToken += 1
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                Button(action: onSettings) { Image(systemName: "gearshape.fill") }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.cyan)
            .padding(8)
            .background(.black.opacity(0.72), in: Capsule())
            .overlay(Capsule().stroke(.cyan.opacity(0.35)))
            .padding(.top, 8)
            .padding(.trailing, 10)

            if let error {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text("JARVIS bağlantısı kurulamadı").font(.headline)
                    Text(error)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    HStack {
                        Button("Ayarlar", action: onSettings)
                            .buttonStyle(.bordered)
                        Button("Tekrar Dene") {
                            self.error = nil
                            self.authorized = false
                            reloadToken += 1
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.cyan)
                    }
                }
                .accessibilityIdentifier("connectionError")
                .padding(24)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .preferredColorScheme(.dark)
        .task(id: reloadToken) {
            await verifyConnection()
        }
    }

    @MainActor
    private func verifyConnection() async {
        guard let dashboardURL = settings.url else {
            loading = false
            error = "Panel bağlantısı geçersiz."
            return
        }
        loading = true
        error = nil
        authorized = false
        do {
            let result = try await ConnectionVerifier.verify(
                dashboardURL: dashboardURL,
                username: settings.username,
                password: settings.password
            )
            switch result {
            case .authorized:
                authorized = true
            case .unauthorized:
                error = "Kullanıcı adı veya parola yanlış. Ayarlar ekranından yeniden gir."
            case .httpError(let status):
                error = status == 0
                    ? "Sunucudan geçerli bir HTTP yanıtı alınamadı."
                    : "Panel HTTP \(status) hatası döndürdü."
            }
        } catch let connectionError {
            error = "Panel bağlantısına ulaşılamadı: \(connectionError.localizedDescription)"
        }
        loading = false
    }
}
