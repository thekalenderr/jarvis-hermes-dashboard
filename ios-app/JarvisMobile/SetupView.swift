import SwiftUI
import UIKit

struct SetupView: View {
    @ObservedObject var settings: AppSettings
    let onConnected: () -> Void
    @State private var securing = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.01, green: 0.03, blue: 0.06), Color(red: 0.02, green: 0.13, blue: 0.18)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            Circle().fill(.cyan.opacity(0.12)).frame(width: 320).blur(radius: 60).offset(y: -260)

            ScrollView {
                VStack(spacing: 24) {
                    reactor
                    VStack(spacing: 8) {
                        Text("JARVIS MOBILE").font(.system(size: 30, weight: .bold, design: .rounded)).tracking(5).foregroundStyle(.white)
                        Text("GÜVENLİ BAĞLANTI MATRİSİ").font(.caption.monospaced()).tracking(2).foregroundStyle(.cyan)
                    }
                    VStack(spacing: 14) {
                        field("HTTPS PANEL BAĞLANTISI", identifier: "dashboardURL", text: $settings.dashboardURL, contentType: .URL, secure: false)
                            .textInputAutocapitalization(.never).keyboardType(.URL)
                        field("KULLANICI ADI", identifier: "username", text: $settings.username, contentType: .username, secure: false)
                            .textInputAutocapitalization(.never)
                        field("PAROLA", identifier: "password", text: $settings.password, contentType: .password, secure: true)
                        if let error = settings.errorMessage {
                            Text(error).font(.footnote.monospaced()).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Button {
                            securing = true
                            if settings.save() { onConnected() }
                            securing = false
                        } label: {
                            HStack { Image(systemName: "lock.shield.fill"); Text(securing ? "BAĞLANIYOR" : "JARVIS'E BAĞLAN") }
                                .font(.headline.monospaced()).tracking(1).frame(maxWidth: .infinity).padding(.vertical, 15)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("connectButton")
                        .foregroundStyle(Color(red: 0.01, green: 0.08, blue: 0.10))
                        .background(.cyan, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(18)
                    .background(.black.opacity(0.36), in: RoundedRectangle(cornerRadius: 24))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(.cyan.opacity(0.35)))

                    Label("Parola yalnızca bu iPhone'un Keychain kasasında tutulur.", systemImage: "checkmark.shield")
                        .font(.caption).foregroundStyle(.white.opacity(0.58))
                }
                .padding(.horizontal, 20).padding(.vertical, 28)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var reactor: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle().stroke(i == 1 ? .orange.opacity(0.65) : .cyan.opacity(0.55), style: StrokeStyle(lineWidth: 2, dash: [CGFloat(5 + i * 3), 8]))
                    .frame(width: CGFloat(150 + i * 34), height: CGFloat(150 + i * 34))
                    .rotationEffect(.degrees(Double(i * 35)))
            }
            Circle().fill(RadialGradient(colors: [.white, .cyan, .cyan.opacity(0.08)], center: .center, startRadius: 1, endRadius: 65)).frame(width: 94, height: 94).shadow(color: .cyan, radius: 24)
            Image(systemName: "waveform.path.ecg").font(.system(size: 34, weight: .medium)).foregroundStyle(Color(red: 0.0, green: 0.14, blue: 0.18))
        }.frame(height: 230)
    }

    @ViewBuilder
    private func field(_ label: String, identifier: String, text: Binding<String>, contentType: UITextContentType?, secure: Bool) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label).font(.caption2.monospaced()).tracking(1.5).foregroundStyle(.cyan.opacity(0.8))
            Group {
                if secure { SecureField("••••••••", text: text) }
                else { TextField("", text: text) }
            }
            .textContentType(contentType).font(.body.monospaced()).padding(13)
            .accessibilityIdentifier(identifier)
            .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.cyan.opacity(0.22)))
        }
    }
}
