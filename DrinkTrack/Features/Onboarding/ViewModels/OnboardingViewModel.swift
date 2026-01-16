import Foundation
import Observation
import SwiftData

@Observable
class OnboardingViewModel {
    var selectedGoal: Int = 2000
    var customGoal: Int?

    let presetGoals = [2000, 2500, 3000]

    func selectGoal(_ goal: Int) {
        selectedGoal = goal
    }

    func applyCustomGoal() {
        guard let custom = customGoal, custom > 0 else { return }
        selectedGoal = custom
    }

    @MainActor
    func completeOnboarding(modelContext: ModelContext) {
        let settings = UserSettings(dailyGoal: selectedGoal)
        settings.hasCompletedOnboarding = true
        modelContext.insert(settings)
        try? modelContext.save()
    }
}
