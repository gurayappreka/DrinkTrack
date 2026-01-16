import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]
    @State private var selectedDate: Date?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Month Navigation
                MonthNavigationView(
                    currentMonth: viewModel.currentMonth,
                    onPrevious: { viewModel.previousMonth() },
                    onNext: { viewModel.nextMonth() }
                )

                // Streak Info
                StreakBadgeView(streak: viewModel.currentStreak)

                // Contribution Grid
                ContributionGridView(
                    monthData: viewModel.monthlyProgress,
                    selectedDate: $selectedDate
                )

                // Day Detail (if selected)
                if let selected = selectedDate,
                   let dayProgress = viewModel.getProgress(for: selected) {
                    DayDetailCard(progress: dayProgress)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Legend
                ContributionLegendView()
            }
            .padding()
        }
        .background(Color("BackgroundColor"))
        .navigationTitle("Geçmiş")
        .onAppear {
            if let userSettings = settings.first {
                viewModel.dailyGoal = userSettings.dailyGoal
            }
            viewModel.loadMonthData(modelContext: modelContext)
        }
        .onChange(of: viewModel.currentMonth) { _, _ in
            viewModel.loadMonthData(modelContext: modelContext)
            selectedDate = nil
        }
    }
}

#Preview {
    NavigationStack {
        CalendarView()
            .modelContainer(for: [WaterIntake.self, UserSettings.self])
    }
}
