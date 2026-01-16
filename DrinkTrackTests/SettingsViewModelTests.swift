import XCTest
@testable import DrinkTrack

final class SettingsViewModelTests: XCTestCase {

    func testDefaultDailyGoalIs2000() {
        let viewModel = SettingsViewModel()
        XCTAssertEqual(viewModel.dailyGoal, 2000)
    }

    func testStatisticsInitializeToZero() {
        let viewModel = SettingsViewModel()
        XCTAssertEqual(viewModel.totalRecords, 0)
        XCTAssertEqual(viewModel.longestStreak, 0)
        XCTAssertEqual(viewModel.averageDaily, 0)
    }

    func testTotalRecordsInitialValue() {
        let viewModel = SettingsViewModel()
        XCTAssertEqual(viewModel.totalRecords, 0)
    }

    func testLongestStreakInitialValue() {
        let viewModel = SettingsViewModel()
        XCTAssertEqual(viewModel.longestStreak, 0)
    }

    func testAverageDailyInitialValue() {
        let viewModel = SettingsViewModel()
        XCTAssertEqual(viewModel.averageDaily, 0)
    }

    func testDailyGoalCanBeChanged() {
        let viewModel = SettingsViewModel()
        viewModel.dailyGoal = 2500
        XCTAssertEqual(viewModel.dailyGoal, 2500)
    }

    func testDailyGoalAcceptsMinimumValue() {
        let viewModel = SettingsViewModel()
        viewModel.dailyGoal = 500
        XCTAssertEqual(viewModel.dailyGoal, 500)
    }

    func testDailyGoalAcceptsMaximumValue() {
        let viewModel = SettingsViewModel()
        viewModel.dailyGoal = 5000
        XCTAssertEqual(viewModel.dailyGoal, 5000)
    }
}
