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
    }
}
