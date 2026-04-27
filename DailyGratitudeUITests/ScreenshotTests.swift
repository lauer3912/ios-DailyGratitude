import XCTest

final class ScreenshotTests: XCTestCase {
    func testHomeViewScreenshot() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("HomeView")
    }

    func testJournalViewScreenshot() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        app.tabBars.buttons["Journal"].tap()
        snapshot("JournalView")
    }

    func testChallengesViewScreenshot() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        app.tabBars.buttons["Challenges"].tap()
        snapshot("ChallengesView")
    }

    func testStatsViewScreenshot() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        app.tabBars.buttons["Stats"].tap()
        snapshot("StatsView")
    }

    private func setupSnapshot(_ app: XCUIApplication) {
        app.launchArguments = ["--reset"]
    }
}
