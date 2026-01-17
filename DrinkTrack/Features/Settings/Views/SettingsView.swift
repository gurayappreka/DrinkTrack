import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]
    @State private var showResetConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Daily Goal Section
                goalSection

                // Statistics Section
                statisticsSection

                // Data Management Section
                dataManagementSection

                // About Section
                aboutSection
            }
            .padding(20)
        }
        .background(Color("BackgroundColor"))
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

    // MARK: - Goal Section
    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hedef Ayarlari")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color("TextSecondary"))
                .padding(.horizontal, 4)

            DTCard {
                VStack(spacing: 20) {
                    // Current Goal Display
                    HStack {
                        Image(systemName: "target")
                            .font(.title3)
                            .foregroundStyle(Color("PrimaryBlue"))
                            .frame(width: 28)

                        Text("Gunluk Hedef")
                            .font(.body)
                            .foregroundStyle(Color("TextPrimary"))

                        Spacer()

                        Text("\(viewModel.dailyGoal) ml")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color("PrimaryBlue"))
                    }
                    .frame(minHeight: 52)

                    Divider()

                    // Stepper
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                            .foregroundStyle(Color("PrimaryBlue"))
                            .frame(width: 28)

                        Text("Hedefi Ayarla")
                            .font(.body)
                            .foregroundStyle(Color("TextPrimary"))

                        Spacer()

                        Stepper(
                            "",
                            value: $viewModel.dailyGoal,
                            in: 500...5000,
                            step: 100
                        )
                        .labelsHidden()
                        .onChange(of: viewModel.dailyGoal) { _, newValue in
                            viewModel.updateGoal(newValue, modelContext: modelContext)
                        }
                    }
                    .frame(minHeight: 52)

                    Divider()

                    // Quick Presets
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hizli Secim")
                            .font(.caption)
                            .foregroundStyle(Color("TextSecondary"))

                        HStack(spacing: 12) {
                            ForEach([1500, 2000, 2500, 3000], id: \.self) { preset in
                                Button {
                                    viewModel.dailyGoal = preset
                                    viewModel.updateGoal(preset, modelContext: modelContext)
                                } label: {
                                    Text("\(preset)")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(
                                            viewModel.dailyGoal == preset
                                            ? .white
                                            : Color("TextPrimary")
                                        )
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(
                                            viewModel.dailyGoal == preset
                                            ? Color("PrimaryBlue")
                                            : Color("BackgroundColor")
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Statistics Section
    private var statisticsSection: some View {
        DTCardSection(
            title: "Istatistikler",
            rows: [
                DTCardRowData(
                    icon: "drop.fill",
                    iconColor: Color("PrimaryBlue"),
                    title: "Toplam Kayit",
                    value: "\(viewModel.totalRecords)"
                ),
                DTCardRowData(
                    icon: "flame.fill",
                    iconColor: .orange,
                    title: "En Uzun Seri",
                    value: "\(viewModel.longestStreak) gun"
                ),
                DTCardRowData(
                    icon: "chart.bar.fill",
                    iconColor: Color("SuccessGreen"),
                    title: "Ortalama Gunluk",
                    value: "\(viewModel.averageDaily) ml"
                )
            ]
        )
    }

    // MARK: - Data Management Section
    private var dataManagementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Veri Yonetimi")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color("TextSecondary"))
                .padding(.horizontal, 4)

            DTCard {
                VStack(spacing: 0) {
                    Button {
                        showResetConfirmation = true
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundStyle(.red)
                                .frame(width: 28)

                            Text("Tum Verileri Sil")
                                .font(.body)
                                .foregroundStyle(.red)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(Color("TextSecondary"))
                        }
                        .frame(minHeight: 52)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("Bu islem geri alinamaz. Tum su tuketim kayitlariniz silinecektir.")
                .font(.caption)
                .foregroundStyle(Color("TextSecondary"))
                .padding(.horizontal, 4)
        }
    }

    // MARK: - About Section
    private var aboutSection: some View {
        DTCardSection(
            title: "Hakkinda",
            rows: [
                DTCardRowData(
                    icon: "info.circle",
                    iconColor: Color("PrimaryBlue"),
                    title: "Versiyon",
                    value: "1.0.0"
                )
            ]
        )
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .modelContainer(for: [WaterIntake.self, UserSettings.self])
    }
}
