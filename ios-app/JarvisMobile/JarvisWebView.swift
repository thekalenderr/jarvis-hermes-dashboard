import SwiftUI
import WebKit

struct JarvisWebView: UIViewRepresentable {
    let url: URL
    let username: String
    let password: String
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    let reloadToken: Int

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = [.audio]
        configuration.applicationNameForUserAgent = "JarvisMobile/1.0.3"
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.load(
            AuthenticatedRequestFactory.request(
                url: url,
                username: username,
                password: password
            )
        )
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.parent = self
        if context.coordinator.lastReloadToken != reloadToken {
            context.coordinator.lastReloadToken = reloadToken
            webView.load(
                AuthenticatedRequestFactory.request(
                    url: url,
                    username: username,
                    password: password
                )
            )
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: JarvisWebView
        var lastReloadToken: Int
        init(_ parent: JarvisWebView) {
            self.parent = parent
            self.lastReloadToken = parent.reloadToken
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true; parent.errorMessage = nil
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false; parent.errorMessage = error.localizedDescription
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false; parent.errorMessage = error.localizedDescription
        }
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            let action = BasicAuthenticationPolicy.action(
                method: challenge.protectionSpace.authenticationMethod,
                host: challenge.protectionSpace.host,
                expectedHost: parent.url.host,
                previousFailures: challenge.previousFailureCount
            )
            switch action {
            case .useCredential:
                completionHandler(
                    .useCredential,
                    URLCredential(
                        user: parent.username,
                        password: parent.password,
                        persistence: .forSession
                    )
                )
            case .reject:
                parent.isLoading = false
                parent.errorMessage = "Kullanıcı adı veya parola kabul edilmedi. Ayarlar ekranından bilgileri yeniden gir."
                completionHandler(.cancelAuthenticationChallenge, nil)
            case .defaultHandling:
                completionHandler(.performDefaultHandling, nil)
            }
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if let response = navigationResponse.response as? HTTPURLResponse,
               response.statusCode >= 400 {
                parent.isLoading = false
                parent.errorMessage = "Panel HTTP \(response.statusCode) hatası döndürdü. Bağlantı ve giriş bilgilerini kontrol et."
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}
