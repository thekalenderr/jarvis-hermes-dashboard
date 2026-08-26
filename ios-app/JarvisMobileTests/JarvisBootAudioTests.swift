import AVFoundation
import XCTest
@testable import JarvisMobile

final class JarvisBootAudioTests: XCTestCase {
    func testNaturalBootAudioIsBundledAndPlayable() throws {
        let url = try XCTUnwrap(
            Bundle.main.url(forResource: "jarvis-boot", withExtension: "m4a")
        )
        let player = try AVAudioPlayer(contentsOf: url)
        XCTAssertEqual(player.numberOfChannels, 2)
        XCTAssertEqual(player.duration, 5.8, accuracy: 0.08)
    }
}
