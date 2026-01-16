import XCTest
@testable import DrinkTrack

final class UserSettingsTests: XCTestCase {

    func testDefaultInitialization() {
        let settings = UserSettings()
        XCTAssertEqual(settings.dailyGoal, 2000)
        XCTAssertFalse(settings.hasCompletedOnboarding)
    }

    func testInitializationWithCustomDailyGoal() {
        let settings = UserSettings(dailyGoal: 3000)
        XCTAssertEqual(settings.dailyGoal, 3000)
        XCTAssertFalse(settings.hasCompletedOnboarding)
    }

    func testCreatedAtIsSetToNow() {
        let before = Date()
        let settings = UserSettings()
        let after = Date()
        XCTAssertGreaterThanOrEqual(settings.createdAt, before)
        XCTAssertLessThanOrEqual(settings.createdAt, after)
    }
}
