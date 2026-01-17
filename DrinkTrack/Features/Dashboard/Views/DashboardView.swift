import SwiftUI
import SwiftData

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Date Selector
                    DateSelectorView(
                        selectedDate: viewModel.selectedDate,
                        selectableDates: viewModel.selectableDates,
                        onDateSelected: { date in
                            viewModel.selectDate(date, modelContext: modelContext)
                        }
                    )

                    // Progress Ring
                    ProgressRingView(
                        progress: viewModel.progress,
                        currentAmount: viewModel.todayTotal,
                        goal: viewModel.dailyGoal
                    )
                    .frame(height: 280)

                    // Quick Add Buttons
                    if viewModel.canAddRecords {
                        QuickAddSection(onAdd: { amount in
                            viewModel.addIntake(amount: amount, modelContext: modelContext)
                        })
                    }

                    // Day's Records
                    DayRecordsSection(
                        intakes: viewModel.todayIntakes,
                        dateLabel: viewModel.formattedSelectedDate,
                        canDelete: viewModel.canAddRecords,
                        onDelete: { intake in
                            viewModel.deleteIntake(intake, modelContext: modelContext)
                        }
                    )
                }
                .padding()
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("DrinkTrack")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: CalendarView()) {
                        Image(systemName: "calendar")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .onAppear {
            if let userSettings = settings.first {
                viewModel.dailyGoal = userSettings.dailyGoal
            }
            viewModel.loadDataForSelectedDate(modelContext: modelContext)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [WaterIntake.self, UserSettings.self])
}
