import XCTest
@testable import DrinkTrack

final class OnboardingViewModelTests: XCTestCase {

    func testDefaultGoalIs2000ml() {
        let viewModel = OnboardingViewModel()
        XCTAssertEqual(viewModel.selectedGoal, 2000)
    }

    func testSelectGoalUpdatesSelectedGoal() {
        let viewModel = OnboardingViewModel()
        viewModel.selectGoal(2500)
        XCTAssertEqual(viewModel.selectedGoal, 2500)
    }

    func testApplyCustomGoalWorks() {
        let viewModel = OnboardingViewModel()
        viewModel.customGoal = 1800
        viewModel.applyCustomGoal()
        XCTAssertEqual(viewModel.selectedGoal, 1800)
    }

    func testInvalidCustomGoalIsIgnored() {
        let viewModel = OnboardingViewModel()
        viewModel.customGoal = 0
        viewModel.applyCustomGoal()
        XCTAssertEqual(viewModel.selectedGoal, 2000) // unchanged
    }

    func testNegativeCustomGoalIsIgnored() {
        let viewModel = OnboardingViewModel()
        viewModel.customGoal = -100
        viewModel.applyCustomGoal()
        XCTAssertEqual(viewModel.selectedGoal, 2000) // unchanged
    }

    func testNilCustomGoalIsIgnored() {
        let viewModel = OnboardingViewModel()
        viewModel.customGoal = nil
        viewModel.applyCustomGoal()
        XCTAssertEqual(viewModel.selectedGoal, 2000) // unchanged
    }

    func testPresetGoalsContainsExpectedValues() {
        let viewModel = OnboardingViewModel()
        XCTAssertEqual(viewModel.presetGoals, [2000, 2500, 3000])
    }
}
