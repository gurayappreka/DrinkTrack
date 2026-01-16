import Foundation
import Observation
import SwiftData

@Observable
class CalendarViewModel {
    var currentMonth: Date = Date()
    var monthlyProgress: [DailyProgress] = []
    var dailyGoal: Int = 2000
    var currentStreak: Int = 0

    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }

    func nextMonth() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        if nextMonth <= Date() {
            currentMonth = nextMonth
        }
    }

    func getProgress(for date: Date) -> DailyProgress? {
        monthlyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    @MainActor
    func loadMonthData(modelContext: ModelContext) {
        let calendar = Calendar.current

        // Get month boundaries
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
            return
        }

        // Generate all days in month
        var days: [DailyProgress] = []
        var currentDate = monthStart

        while currentDate <= monthEnd && currentDate <= Date() {
            let dayStart = calendar.startOfDay(for: currentDate)
            guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
                break
            }

            let descriptor = FetchDescriptor<WaterIntake>(
                predicate: #Predicate { intake in
                    intake.timestamp >= dayStart && intake.timestamp < dayEnd
                }
            )

            do {
                let intakes = try modelContext.fetch(descriptor)
                let total = intakes.reduce(0) { $0 + $1.amount }
                days.append(DailyProgress(date: currentDate, totalAmount: total, goal: dailyGoal))
            } catch {
                days.append(DailyProgress(date: currentDate, totalAmount: 0, goal: dailyGoal))
            }

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        monthlyProgress = days
        calculateStreak(modelContext: modelContext)
    }

    @MainActor
    private func calculateStreak(modelContext: ModelContext) {
        var streak = 0
        guard var checkDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            currentStreak = 0
            return
        }

        while true {
            guard let progress = getProgressForDate(checkDate, modelContext: modelContext) else { break }
            if progress.isGoalMet {
                streak += 1
                guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) else {
                    break
                }
                checkDate = previousDate
            } else {
                break
            }
        }

        // Check today
        if let todayProgress = getProgressForDate(Date(), modelContext: modelContext),
           todayProgress.isGoalMet {
            streak += 1
        }

        currentStreak = streak
    }

    @MainActor
    private func getProgressForDate(_ date: Date, modelContext: ModelContext) -> DailyProgress? {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return nil
        }

        let descriptor = FetchDescriptor<WaterIntake>(
            predicate: #Predicate { intake in
                intake.timestamp >= dayStart && intake.timestamp < dayEnd
            }
        )

        do {
            let intakes = try modelContext.fetch(descriptor)
            let total = intakes.reduce(0) { $0 + $1.amount }
            return DailyProgress(date: date, totalAmount: total, goal: dailyGoal)
        } catch {
            return nil
        }
    }
}
