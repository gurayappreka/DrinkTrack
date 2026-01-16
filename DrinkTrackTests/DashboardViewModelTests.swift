import XCTest
@testable import DrinkTrack

final class DashboardViewModelTests: XCTestCase {

    func testProgressCalculationIsCorrect() {
        let viewModel = DashboardViewModel()
        viewModel.todayTotal = 1000
        viewModel.dailyGoal = 2000
        XCTAssertEqual(viewModel.progress, 0.5)
    }

    func testProgressOver100IsAllowed() {
        let viewModel = DashboardViewModel()
        viewModel.todayTotal = 2500
        viewModel.dailyGoal = 2000
        XCTAssertEqual(viewModel.progress, 1.25)
    }

    func testZeroGoalReturnsZeroProgress() {
        let viewModel = DashboardViewModel()
        viewModel.dailyGoal = 0
        viewModel.todayTotal = 1000
        XCTAssertEqual(viewModel.progress, 0)
    }

    func testDefaultDailyGoalIs2000() {
        let viewModel = DashboardViewModel()
        XCTAssertEqual(viewModel.dailyGoal, 2000)
    }

    func testInitialTodayTotalIsZero() {
        let viewModel = DashboardViewModel()
        XCTAssertEqual(viewModel.todayTotal, 0)
    }

    func testInitialTodayIntakesIsEmpty() {
        let viewModel = DashboardViewModel()
        XCTAssertTrue(viewModel.todayIntakes.isEmpty)
    }

    func testProgressAt100Percent() {
        let viewModel = DashboardViewModel()
        viewModel.todayTotal = 2000
        viewModel.dailyGoal = 2000
        XCTAssertEqual(viewModel.progress, 1.0)
    }

    func testProgressWithSmallValues() {
        let viewModel = DashboardViewModel()
        viewModel.todayTotal = 250
        viewModel.dailyGoal = 2000
        XCTAssertEqual(viewModel.progress, 0.125)
    }
}
