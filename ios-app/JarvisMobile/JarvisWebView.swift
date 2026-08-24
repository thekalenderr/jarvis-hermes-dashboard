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
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.load(URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.parent = self
        if context.coordinator.lastReloadToken != reloadToken {
            context.coordinator.lastReloadToken = reloadToken
            webView.reloadFromOrigin()
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
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic,
               challenge.protectionSpace.host == parent.url.host {
                completionHandler(.useCredential, URLCredential(user: parent.username, password: parent.password, persistence: .forSession))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        }
    }
}
