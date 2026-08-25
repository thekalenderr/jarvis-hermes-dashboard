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
            TestSecrets.password.isEmpty ? nil : TestSecrets.password,
            "CI must generate TestSecrets.password"
        )
        let app = freshApp()
        let passwordField = app.secureTextFields["password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText(password + "\n")
        app.buttons["connectButton"].tap()

        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 20))
        XCTAssertFalse(app.otherElements["connectionError"].exists)
    }

    func testWrongCredentialsShowErrorInsteadOfBlackScreen() {
        let app = freshApp()
        let passwordField = app.secureTextFields["password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("yanlis-parola\n")
        app.buttons["connectButton"].tap()

        XCTAssertTrue(
            app.otherElements["connectionError"].waitForExistence(timeout: 20)
        )
    }
}
