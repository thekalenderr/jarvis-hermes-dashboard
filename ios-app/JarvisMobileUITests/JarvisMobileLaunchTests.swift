import XCTest

final class JarvisMobileLaunchTests: XCTestCase {
    func testFreshInstallOpensConnectionScreen() {
        let app = XCUIApplication()
        app.launchArguments += [
            "--uitesting-reset",
            "-AppleLanguages", "(tr)",
            "-AppleLocale", "tr_TR",
        ]
        app.launch()

        XCTAssertTrue(app.staticTexts["JARVIS MOBILE"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["connectButton"].exists)
        XCTAssertTrue(app.otherElements["jarvisCore"].exists)

        let preview = XCTAttachment(screenshot: app.screenshot())
        preview.name = "Jarvis-Mobile-login"
        preview.lifetime = .keepAlways
        add(preview)
    }

    func testConfiguredAppShowsInterface5() {
        let app = XCUIApplication()
        app.launchArguments += ["--uitesting-reset"]
        app.launch()

        XCTAssertTrue(app.textFields["dashboardURL"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.textFields["username"].exists)

        let password = app.secureTextFields["password"]
        password.tap()
        password.typeText(TestSecrets.password)
        app.buttons["connectButton"].tap()

        let dashboard = app.webViews["dashboardWebView"]
        XCTAssertTrue(dashboard.waitForExistence(timeout: 15), "Authenticated Interface 5 webview should appear")
        sleep(3)

        let preview = XCTAttachment(screenshot: app.screenshot())
        preview.name = "Jarvis-Mobile-interface-5"
        preview.lifetime = .keepAlways
        add(preview)
    }
}
