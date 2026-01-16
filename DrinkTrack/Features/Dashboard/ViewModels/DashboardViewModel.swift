import Foundation
import Observation
import SwiftData

@Observable
class DashboardViewModel {
    var todayIntakes: [WaterIntake] = []
    var todayTotal: Int = 0
    var dailyGoal: Int = 2000

    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return Double(todayTotal) / Double(dailyGoal)
    }

    @MainActor
    func loadTodayData(modelContext: ModelContext) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        let descriptor = FetchDescriptor<WaterIntake>(
            predicate: #Predicate { intake in
                intake.timestamp >= startOfDay && intake.timestamp < endOfDay
            },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        do {
            todayIntakes = try modelContext.fetch(descriptor)
            todayTotal = todayIntakes.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error loading intakes: \(error)")
        }
    }

    @MainActor
    func addIntake(amount: Int, modelContext: ModelContext) {
        let intake = WaterIntake(amount: amount)
        modelContext.insert(intake)
        try? modelContext.save()
        loadTodayData(modelContext: modelContext)
    }

    @MainActor
    func deleteIntake(_ intake: WaterIntake, modelContext: ModelContext) {
        modelContext.delete(intake)
        try? modelContext.save()
        loadTodayData(modelContext: modelContext)
    }
}
