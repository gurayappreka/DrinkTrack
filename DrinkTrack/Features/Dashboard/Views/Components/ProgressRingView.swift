import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    let currentAmount: Int
    let goal: Int

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            // Background Ring
            Circle()
                .stroke(Color("ContributionLevel0"), lineWidth: 20)

            // Progress Ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    progress >= 1.0 ? Color("SuccessGreen") : Color("PrimaryBlue"),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.3), value: animatedProgress)

            // Center Content
            VStack(spacing: 8) {
                Text("\(currentAmount)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                    .contentTransition(.numericText())

                Text("/ \(goal) ml")
                    .font(.subheadline)
                    .foregroundStyle(Color("TextSecondary"))

                if progress >= 1.0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Hedef Tamamlandı!")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(Color("SuccessGreen"))
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = min(progress, 1.0)
            }
        }
        .onChange(of: progress) {
            withAnimation(.easeOut(duration: 0.3)) {
                animatedProgress = min(progress, 1.0)
            }
        }
    }
}

#Preview {
    ProgressRingView(progress: 0.65, currentAmount: 1300, goal: 2000)
        .frame(height: 280)
}
