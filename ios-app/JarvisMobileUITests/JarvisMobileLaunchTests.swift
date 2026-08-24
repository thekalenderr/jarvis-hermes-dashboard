import XCTest

final class JarvisMobileLaunchTests: XCTestCase {
    private func freshApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += [
            "--uitesting-reset",
            "-AppleLanguages", "(tr)",
            "-AppleLocale", "tr_TR",
        ]
        app.launch()
        return app
    }

    func testFreshInstallOpensConnectionScreen() {
        let app = freshApp()
        XCTAssertTrue(app.staticTexts["JARVIS MOBILE"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["connectButton"].exists)
    }

    func testCorrectCredentialsOpenLiveJarvisPanel() throws {
        let password = try XCTUnwrap(
            ProcessInfo.processInfo.environment["JARVIS_TEST_PASSWORD"],
            "CI must provide JARVIS_TEST_PASSWORD"
        )
        let app = freshApp()
        let passwordField = app.secureTextFields["password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText(password)
        app.buttons["connectButton"].tap()

        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts["JARVIS"].waitForExistence(timeout: 25))
    }

    func testWrongCredentialsShowErrorInsteadOfBlackScreen() {
        let app = freshApp()
        let passwordField = app.secureTextFields["password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("yanlis-parola")
        app.buttons["connectButton"].tap()

        XCTAssertTrue(
            app.staticTexts["JARVIS bağlantısı kurulamadı"].waitForExistence(timeout: 20)
        )
    }
}
