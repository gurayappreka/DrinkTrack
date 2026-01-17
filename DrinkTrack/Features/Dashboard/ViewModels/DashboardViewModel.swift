import Foundation
import Observation
import SwiftData

@Observable
class DashboardViewModel {
    var todayIntakes: [WaterIntake] = []
    var todayTotal: Int = 0
    var dailyGoal: Int = 2000
    var selectedDate: Date = Date()

    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return Double(todayTotal) / Double(dailyGoal)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    var canAddRecords: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selected = calendar.startOfDay(for: selectedDate)

        guard let daysAgo = calendar.dateComponents([.day], from: selected, to: today).day else {
            return false
        }
        return daysAgo >= 0 && daysAgo <= 3
    }

    var selectableDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dates: [Date] = []
        for daysBack in 0...3 {
            if let date = calendar.date(byAdding: .day, value: -daysBack, to: today) {
                dates.append(date)
            }
        }
        return dates
    }

    var formattedSelectedDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Bugun"
        } else if calendar.isDateInYesterday(selectedDate) {
            return "Dun"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "d MMMM"
            return formatter.string(from: selectedDate)
        }
    }

    @MainActor
    func loadDataForSelectedDate(modelContext: ModelContext) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
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
    func selectDate(_ date: Date, modelContext: ModelContext) {
        selectedDate = date
        loadDataForSelectedDate(modelContext: modelContext)
    }

    @MainActor
    func addIntake(amount: Int, modelContext: ModelContext) {
        guard canAddRecords else { return }
        let calendar = Calendar.current
        let now = Date()
        let timestamp: Date
        if calendar.isDateInToday(selectedDate) {
            timestamp = now
        } else {
            let selectedDayStart = calendar.startOfDay(for: selectedDate)
            let hour = calendar.component(.hour, from: now)
            let minute = calendar.component(.minute, from: now)
            timestamp = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDayStart) ?? selectedDayStart
        }
        let intake = WaterIntake(amount: amount, timestamp: timestamp)
        modelContext.insert(intake)
        try? modelContext.save()
        loadDataForSelectedDate(modelContext: modelContext)
    }

    @MainActor
    func deleteIntake(_ intake: WaterIntake, modelContext: ModelContext) {
        modelContext.delete(intake)
        try? modelContext.save()
        loadDataForSelectedDate(modelContext: modelContext)
    }
}
