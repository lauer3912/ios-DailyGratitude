import XCTest
@testable import DailyGratitude

final class DailyGratitudeTests: XCTestCase {
    func testGratitudeEntryCreation() {
        let entry = GratitudeEntry(date: Date(), text: "Test gratitude", mood: 4, wordCount: 3)
        XCTAssertEqual(entry.text, "Test gratitude")
        XCTAssertEqual(entry.mood, 4)
        XCTAssertEqual(entry.wordCount, 3)
    }

    func testChallengeInitialization() {
        let challenge = Challenge()
        XCTAssertEqual(challenge.currentDay, 1)
        XCTAssertFalse(challenge.isCompleted)
    }
}
