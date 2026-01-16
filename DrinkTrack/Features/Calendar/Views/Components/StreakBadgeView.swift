import SwiftUI

struct StreakBadgeView: View {
    let streak: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .foregroundStyle(.orange)

            Text("\(streak) Gün Seri")
                .font(.subheadline.bold())

            if streak >= 7 {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("CardColor"))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#Preview {
    VStack(spacing: 16) {
        StreakBadgeView(streak: 3)
        StreakBadgeView(streak: 7)
        StreakBadgeView(streak: 14)
    }
    .padding()
    .background(Color("BackgroundColor"))
}
