import XCTest
@testable import DrinkTrack

final class DailyProgressTests: XCTestCase {

    func testContributionLevel0For0Percent() {
        let progress = DailyProgress(date: .now, totalAmount: 0, goal: 2000)
        XCTAssertEqual(progress.contributionLevel, 0)
        XCTAssertEqual(progress.percentage, 0)
        XCTAssertFalse(progress.isGoalMet)
    }

    func testContributionLevel1For1To24Percent() {
        let progress = DailyProgress(date: .now, totalAmount: 400, goal: 2000)
        XCTAssertEqual(progress.contributionLevel, 1)
        XCTAssertEqual(progress.percentage, 0.2)
        XCTAssertFalse(progress.isGoalMet)
    }

    func testContributionLevel2For25To49Percent() {
        let progress = DailyProgress(date: .now, totalAmount: 800, goal: 2000)
        XCTAssertEqual(progress.contributionLevel, 2)
        XCTAssertEqual(progress.percentage, 0.4)
        XCTAssertFalse(progress.isGoalMet)
    }

    func testContributionLevel3For50To99Percent() {
        let progress = DailyProgress(date: .now, totalAmount: 1500, goal: 2000)
        XCTAssertEqual(progress.contributionLevel, 3)
        XCTAssertEqual(progress.percentage, 0.75)
        XCTAssertFalse(progress.isGoalMet)
    }

    func testContributionLevel4For100PercentAndAbove() {
        let progress = DailyProgress(date: .now, totalAmount: 2500, goal: 2000)
        XCTAssertEqual(progress.contributionLevel, 4)
        XCTAssertTrue(progress.isGoalMet)
    }

    func testPercentageCappedAt1() {
        let progress = DailyProgress(date: .now, totalAmount: 3000, goal: 2000)
        XCTAssertEqual(progress.percentage, 1.0)
    }

    func testPercentageIs0WhenGoalIs0() {
        let progress = DailyProgress(date: .now, totalAmount: 1000, goal: 0)
        XCTAssertEqual(progress.percentage, 0)
    }

    func testGoalMetExactlyAt100Percent() {
        let progress = DailyProgress(date: .now, totalAmount: 2000, goal: 2000)
        XCTAssertTrue(progress.isGoalMet)
        XCTAssertEqual(progress.percentage, 1.0)
        XCTAssertEqual(progress.contributionLevel, 4)
    }
}
