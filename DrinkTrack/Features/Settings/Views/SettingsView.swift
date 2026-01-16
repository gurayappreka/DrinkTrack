import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]
    @State private var showResetConfirmation = false

    var body: some View {
        List {
            // Daily Goal Section
            Section {
                HStack {
                    Label("Gunluk Hedef", systemImage: "target")
                    Spacer()
                    Text("\(viewModel.dailyGoal) ml")
                        .foregroundStyle(Color("TextSecondary"))
                }

                Stepper(
                    value: $viewModel.dailyGoal,
                    in: 500...5000,
                    step: 100
                ) {
                    Text("Hedefi Ayarla")
                }
                .onChange(of: viewModel.dailyGoal) { _, newValue in
                    viewModel.updateGoal(newValue, modelContext: modelContext)
                }

                // Quick Presets
                HStack(spacing: 8) {
                    ForEach([1500, 2000, 2500, 3000], id: \.self) { preset in
                        Button("\(preset)") {
                            viewModel.dailyGoal = preset
                            viewModel.updateGoal(preset, modelContext: modelContext)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.dailyGoal == preset ? Color("PrimaryBlue") : .gray)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text("Hedef Ayarlari")
            }

            // Statistics Section
            Section {
                HStack {
                    Label("Toplam Kayit", systemImage: "drop.fill")
                    Spacer()
                    Text("\(viewModel.totalRecords)")
                        .foregroundStyle(Color("TextSecondary"))
                }

                HStack {
                    Label("En Uzun Seri", systemImage: "flame.fill")
                    Spacer()
                    Text("\(viewModel.longestStreak) gun")
                        .foregroundStyle(Color("TextSecondary"))
                }

                HStack {
                    Label("Ortalama Gunluk", systemImage: "chart.bar.fill")
                    Spacer()
                    Text("\(viewModel.averageDaily) ml")
                        .foregroundStyle(Color("TextSecondary"))
                }
            } header: {
                Text("Istatistikler")
            }

            // Data Management Section
            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Label("Tum Verileri Sil", systemImage: "trash")
                }
            } header: {
                Text("Veri Yonetimi")
            } footer: {
                Text("Bu islem geri alinamaz. Tum su tuketim kayitlariniz silinecektir.")
            }

            // About Section
            Section {
                HStack {
                    Label("Versiyon", systemImage: "info.circle")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(Color("TextSecondary"))
                }

                if let url = URL(string: "https://github.com/example/drinktrack") {
                    Link(destination: url) {
                        Label("GitHub", systemImage: "link")
                    }
                }
            } header: {
                Text("Hakkinda")
            }
        }
        .navigationTitle("Ayarlar")
        .onAppear {
            if let userSettings = settings.first {
                viewModel.dailyGoal = userSettings.dailyGoal
            }
            viewModel.loadStatistics(modelContext: modelContext)
        }
        .confirmationDialog(
            "Tum Verileri Sil",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Sil", role: .destructive) {
                viewModel.resetAllData(modelContext: modelContext)
            }
            Button("Iptal", role: .cancel) {}
        } message: {
            Text("Tum su tuketim kayitlariniz kalici olarak silinecektir. Bu islem geri alinamaz.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .modelContainer(for: [WaterIntake.self, UserSettings.self])
    }
}
