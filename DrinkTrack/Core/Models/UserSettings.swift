import Foundation
import SwiftData

@Model
class UserSettings {
    var dailyGoal: Int // ml cinsinden
    var hasCompletedOnboarding: Bool
    var createdAt: Date

    init(dailyGoal: Int = 2000) {
        self.dailyGoal = dailyGoal
        self.hasCompletedOnboarding = false
        self.createdAt = .now
    }
}
