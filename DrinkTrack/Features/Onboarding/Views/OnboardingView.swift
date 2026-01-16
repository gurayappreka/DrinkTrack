import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Header
            VStack(spacing: 16) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color("PrimaryBlue"))

                Text("DrinkTrack")
                    .font(.largeTitle.bold())

                Text("Günlük su tüketim hedefinizi belirleyin")
                    .font(.subheadline)
                    .foregroundStyle(Color("TextSecondary"))
            }

            Spacer()

            // Goal Selection
            VStack(spacing: 16) {
                Text("Günlük Hedef")
                    .font(.headline)

                // Preset Buttons
                HStack(spacing: 12) {
                    ForEach(viewModel.presetGoals, id: \.self) { goal in
                        GoalButton(
                            amount: goal,
                            isSelected: viewModel.selectedGoal == goal,
                            action: { viewModel.selectGoal(goal) }
                        )
                    }
                }

                // Custom Input
                HStack {
                    TextField("Özel", value: $viewModel.customGoal, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 100)

                    Text("ml")
                        .foregroundStyle(Color("TextSecondary"))

                    Button("Uygula") {
                        viewModel.applyCustomGoal()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color("CardColor"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)

            Spacer()

            // Continue Button
            Button {
                viewModel.completeOnboarding(modelContext: modelContext)
            } label: {
                Text("Başla")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.selectedGoal == 0)
            .opacity(viewModel.selectedGoal == 0 ? 0.5 : 1)
        }
        .padding(24)
        .background(Color("BackgroundColor"))
    }
}

// MARK: - Goal Button Component
struct GoalButton: View {
    let amount: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(amount)")
                    .font(.title2.bold())
                Text("ml")
                    .font(.caption)
            }
            .frame(width: 80, height: 70)
            .background(isSelected ? Color("PrimaryBlue") : Color("CardColor"))
            .foregroundStyle(isSelected ? .white : Color("TextPrimary"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("PrimaryBlue"), lineWidth: isSelected ? 0 : 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    OnboardingView()
}
