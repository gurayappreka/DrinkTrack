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

    // MARK: - Date Selection Tests

    func testInitialSelectedDateIsToday() {
        let viewModel = DashboardViewModel()
        XCTAssertTrue(Calendar.current.isDateInToday(viewModel.selectedDate))
    }

    func testIsTodayReturnsTrueForToday() {
        let viewModel = DashboardViewModel()
        viewModel.selectedDate = Date()
        XCTAssertTrue(viewModel.isToday)
    }

    func testIsTodayReturnsFalseForYesterday() {
        let viewModel = DashboardViewModel()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            XCTFail("Could not create yesterday date")
            return
        }
        viewModel.selectedDate = yesterday
        XCTAssertFalse(viewModel.isToday)
    }

    func testCanAddRecordsForToday() {
        let viewModel = DashboardViewModel()
        viewModel.selectedDate = Date()
        XCTAssertTrue(viewModel.canAddRecords)
    }

    func testCanAddRecordsForYesterday() {
        let viewModel = DashboardViewModel()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            XCTFail("Could not create yesterday date")
            return
        }
        viewModel.selectedDate = yesterday
        XCTAssertTrue(viewModel.canAddRecords)
    }

    func testCanAddRecordsFor2DaysAgo() {
        let viewModel = DashboardViewModel()
        guard let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date()) else {
            XCTFail("Could not create date")
            return
        }
        viewModel.selectedDate = twoDaysAgo
        XCTAssertTrue(viewModel.canAddRecords)
    }

    func testCanAddRecordsFor3DaysAgo() {
        let viewModel = DashboardViewModel()
        guard let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else {
            XCTFail("Could not create date")
            return
        }
        viewModel.selectedDate = threeDaysAgo
        XCTAssertTrue(viewModel.canAddRecords)
    }

    func testCannotAddRecordsFor4DaysAgo() {
        let viewModel = DashboardViewModel()
        guard let fourDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date()) else {
            XCTFail("Could not create date")
            return
        }
        viewModel.selectedDate = fourDaysAgo
        XCTAssertFalse(viewModel.canAddRecords)
    }

    func testCannotAddRecordsForFuture() {
        let viewModel = DashboardViewModel()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
            XCTFail("Could not create date")
            return
        }
        viewModel.selectedDate = tomorrow
        XCTAssertFalse(viewModel.canAddRecords)
    }

    func testSelectableDatesContains4Days() {
        let viewModel = DashboardViewModel()
        XCTAssertEqual(viewModel.selectableDates.count, 4)
    }

    func testSelectableDatesFirstIsToday() {
        let viewModel = DashboardViewModel()
        guard let firstDate = viewModel.selectableDates.first else {
            XCTFail("Selectable dates is empty")
            return
        }
        XCTAssertTrue(Calendar.current.isDateInToday(firstDate))
    }

    func testFormattedSelectedDateForToday() {
        let viewModel = DashboardViewModel()
        viewModel.selectedDate = Date()
        XCTAssertEqual(viewModel.formattedSelectedDate, "Bugun")
    }

    func testFormattedSelectedDateForYesterday() {
        let viewModel = DashboardViewModel()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            XCTFail("Could not create yesterday date")
            return
        }
        viewModel.selectedDate = yesterday
        XCTAssertEqual(viewModel.formattedSelectedDate, "Dun")
    }
}
