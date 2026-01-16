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
                    // Progress Ring
                    ProgressRingView(
                        progress: viewModel.progress,
                        currentAmount: viewModel.todayTotal,
                        goal: viewModel.dailyGoal
                    )
                    .frame(height: 280)

                    // Quick Add Buttons
                    QuickAddSection(onAdd: { amount in
                        viewModel.addIntake(amount: amount, modelContext: modelContext)
                    })

                    // Today's Records
                    TodayRecordsSection(
                        intakes: viewModel.todayIntakes,
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
            viewModel.loadTodayData(modelContext: modelContext)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [WaterIntake.self, UserSettings.self])
}
