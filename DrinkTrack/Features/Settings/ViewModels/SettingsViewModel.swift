import Foundation
import Observation
import SwiftData

@Observable
class SettingsViewModel {
    var dailyGoal: Int = 2000
    var totalRecords: Int = 0
    var longestStreak: Int = 0
    var averageDaily: Int = 0

    @MainActor
    func updateGoal(_ newGoal: Int, modelContext: ModelContext) {
        let descriptor = FetchDescriptor<UserSettings>()

        do {
            let settings = try modelContext.fetch(descriptor)
            if let userSettings = settings.first {
                userSettings.dailyGoal = newGoal
                try modelContext.save()
            }
        } catch {
            print("Error updating goal: \(error)")
        }
    }

    @MainActor
    func loadStatistics(modelContext: ModelContext) {
        // Total Records
        let intakeDescriptor = FetchDescriptor<WaterIntake>()
        do {
            let intakes = try modelContext.fetch(intakeDescriptor)
            totalRecords = intakes.count

            // Calculate average daily
            if !intakes.isEmpty {
                let calendar = Calendar.current
                let uniqueDays = Set(intakes.map { calendar.startOfDay(for: $0.timestamp) })
                let totalAmount = intakes.reduce(0) { $0 + $1.amount }
                averageDaily = uniqueDays.isEmpty ? 0 : totalAmount / uniqueDays.count
            }

            // Calculate longest streak
            longestStreak = calculateLongestStreak(intakes: intakes)
        } catch {
            print("Error loading statistics: \(error)")
        }
    }

    private func calculateLongestStreak(intakes: [WaterIntake]) -> Int {
        guard !intakes.isEmpty else { return 0 }

        let calendar = Calendar.current

        // Group by day and calculate totals
        var dailyTotals: [Date: Int] = [:]
        for intake in intakes {
            let day = calendar.startOfDay(for: intake.timestamp)
            dailyTotals[day, default: 0] += intake.amount
        }

        // Sort days
        let sortedDays = dailyTotals.keys.sorted()

        var maxStreak = 0
        var currentStreak = 0
        var previousDay: Date?

        for day in sortedDays {
            let total = dailyTotals[day] ?? 0
            let isGoalMet = total >= dailyGoal

            if isGoalMet {
                if let prev = previousDay,
                   calendar.dateComponents([.day], from: prev, to: day).day == 1 {
                    currentStreak += 1
                } else {
                    currentStreak = 1
                }
                maxStreak = max(maxStreak, currentStreak)
                previousDay = day
            } else {
                currentStreak = 0
                previousDay = nil
            }
        }

        return maxStreak
    }

    @MainActor
    func resetAllData(modelContext: ModelContext) {
        // Delete all water intakes
        do {
            try modelContext.delete(model: WaterIntake.self)
            try modelContext.save()

            // Reset statistics
            totalRecords = 0
            longestStreak = 0
            averageDaily = 0
        } catch {
            print("Error resetting data: \(error)")
        }
    }
}
