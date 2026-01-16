import XCTest
@testable import DrinkTrack

final class CalendarViewModelTests: XCTestCase {

    func testPreviousMonthNavigation() {
        let viewModel = CalendarViewModel()
        let initialMonth = viewModel.currentMonth
        viewModel.previousMonth()

        let calendar = Calendar.current
        let expectedMonth = calendar.date(byAdding: .month, value: -1, to: initialMonth)!

        XCTAssertTrue(calendar.isDate(viewModel.currentMonth, equalTo: expectedMonth, toGranularity: .month))
    }

    func testNextMonthBlockedForCurrentMonth() {
        let viewModel = CalendarViewModel()
        // Set to current month
        viewModel.currentMonth = Date()
        let initialMonth = viewModel.currentMonth
        viewModel.nextMonth()

        let calendar = Calendar.current
        XCTAssertTrue(calendar.isDate(viewModel.currentMonth, equalTo: initialMonth, toGranularity: .month))
    }

    func testNextMonthAllowedForPastMonth() {
        let viewModel = CalendarViewModel()
        let calendar = Calendar.current
        // Set to 2 months ago
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: Date())!
        viewModel.currentMonth = twoMonthsAgo

        viewModel.nextMonth()

        let expectedMonth = calendar.date(byAdding: .month, value: -1, to: Date())!
        XCTAssertTrue(calendar.isDate(viewModel.currentMonth, equalTo: expectedMonth, toGranularity: .month))
    }

    func testDefaultDailyGoalIs2000() {
        let viewModel = CalendarViewModel()
        XCTAssertEqual(viewModel.dailyGoal, 2000)
    }

    func testInitialStreakIsZero() {
        let viewModel = CalendarViewModel()
        XCTAssertEqual(viewModel.currentStreak, 0)
    }

    func testInitialMonthlyProgressIsEmpty() {
        let viewModel = CalendarViewModel()
        XCTAssertTrue(viewModel.monthlyProgress.isEmpty)
    }

    func testGetProgressReturnsNilForEmptyData() {
        let viewModel = CalendarViewModel()
        let result = viewModel.getProgress(for: Date())
        XCTAssertNil(result)
    }

    func testGetProgressReturnsCorrectDay() {
        let viewModel = CalendarViewModel()
        let today = Date()
        let progress = DailyProgress(date: today, totalAmount: 1500, goal: 2000)
        viewModel.monthlyProgress = [progress]

        let result = viewModel.getProgress(for: today)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.totalAmount, 1500)
    }

    func testMultiplePreviousMonthNavigations() {
        let viewModel = CalendarViewModel()
        let calendar = Calendar.current

        viewModel.previousMonth()
        viewModel.previousMonth()
        viewModel.previousMonth()

        let expectedMonth = calendar.date(byAdding: .month, value: -3, to: Date())!
        XCTAssertTrue(calendar.isDate(viewModel.currentMonth, equalTo: expectedMonth, toGranularity: .month))
    }

    func testCurrentMonthInitializesToNow() {
        let viewModel = CalendarViewModel()
        let calendar = Calendar.current
        XCTAssertTrue(calendar.isDate(viewModel.currentMonth, equalTo: Date(), toGranularity: .month))
    }
}
