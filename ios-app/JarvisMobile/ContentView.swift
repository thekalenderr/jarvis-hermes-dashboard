import SwiftUI

struct ContentView: View {
    @StateObject private var settings = AppSettings()
    @State private var showDashboard = false

    var body: some View {
        Group {
            if showDashboard && settings.hasConfiguration {
                DashboardView(settings: settings) { showDashboard = false }
            } else {
                SetupView(settings: settings) { showDashboard = true }
            }
        }
        .onAppear { showDashboard = settings.hasConfiguration }
    }
}
