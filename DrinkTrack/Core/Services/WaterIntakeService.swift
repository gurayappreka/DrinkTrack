import Foundation
import SwiftData

protocol WaterIntakeServiceProtocol {
    func addIntake(amount: Int) async throws
    func getTodayIntakes() async throws -> [WaterIntake]
    func getTodayTotal() async throws -> Int
    func getIntakes(for date: Date) async throws -> [WaterIntake]
    func deleteIntake(_ intake: WaterIntake) async throws
    func getMonthlyProgress(for month: Date) async throws -> [DailyProgress]
}

@MainActor
class WaterIntakeService: WaterIntakeServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addIntake(amount: Int) async throws {
        let intake = WaterIntake(amount: amount)
        modelContext.insert(intake)
        try modelContext.save()
    }

    func getTodayIntakes() async throws -> [WaterIntake] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }

        let descriptor = FetchDescriptor<WaterIntake>(
            predicate: #Predicate { intake in
                intake.timestamp >= startOfDay && intake.timestamp < endOfDay
            },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func getTodayTotal() async throws -> Int {
        let intakes = try await getTodayIntakes()
        return intakes.reduce(0) { $0 + $1.amount }
    }

    func getIntakes(for date: Date) async throws -> [WaterIntake] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }

        let descriptor = FetchDescriptor<WaterIntake>(
            predicate: #Predicate { intake in
                intake.timestamp >= startOfDay && intake.timestamp < endOfDay
            },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func deleteIntake(_ intake: WaterIntake) async throws {
        modelContext.delete(intake)
        try modelContext.save()
    }

    func getMonthlyProgress(for month: Date) async throws -> [DailyProgress] {
        let calendar = Calendar.current

        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }

        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end

        let descriptor = FetchDescriptor<WaterIntake>(
            predicate: #Predicate { intake in
                intake.timestamp >= startOfMonth && intake.timestamp < endOfMonth
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )

        let intakes = try modelContext.fetch(descriptor)

        // UserSettings'den daily goal al
        let settingsDescriptor = FetchDescriptor<UserSettings>()
        let settings = try modelContext.fetch(settingsDescriptor)
        let dailyGoal = settings.first?.dailyGoal ?? 2000

        // Intakes'i günlere göre grupla
        var dailyTotals: [Date: Int] = [:]

        for intake in intakes {
            let dayStart = calendar.startOfDay(for: intake.timestamp)
            dailyTotals[dayStart, default: 0] += intake.amount
        }

        // Ayın her günü için DailyProgress oluştur
        var progressList: [DailyProgress] = []
        var currentDate = startOfMonth

        while currentDate < endOfMonth {
            let dayStart = calendar.startOfDay(for: currentDate)
            let total = dailyTotals[dayStart] ?? 0

            let progress = DailyProgress(
                date: dayStart,
                totalAmount: total,
                goal: dailyGoal
            )
            progressList.append(progress)

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return progressList
    }
}
