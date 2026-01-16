import SwiftUI

struct DayDetailCard: View {
    let progress: DailyProgress

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM yyyy, EEEE"
        return formatter.string(from: progress.date)
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(dateText)
                .font(.subheadline)
                .foregroundStyle(Color("TextSecondary"))

            HStack(spacing: 24) {
                VStack {
                    Text("\(progress.totalAmount)")
                        .font(.title.bold())
                    Text("ml içildi")
                        .font(.caption)
                        .foregroundStyle(Color("TextSecondary"))
                }

                VStack {
                    Text("\(Int(progress.percentage * 100))%")
                        .font(.title.bold())
                        .foregroundStyle(progress.isGoalMet ? Color("SuccessGreen") : Color("PrimaryBlue"))
                    Text("hedef")
                        .font(.caption)
                        .foregroundStyle(Color("TextSecondary"))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#Preview {
    VStack(spacing: 16) {
        DayDetailCard(
            progress: DailyProgress(
                date: Date(),
                totalAmount: 1500,
                goal: 2000
            )
        )

        DayDetailCard(
            progress: DailyProgress(
                date: Date(),
                totalAmount: 2200,
                goal: 2000
            )
        )
    }
    .padding()
    .background(Color("BackgroundColor"))
}
