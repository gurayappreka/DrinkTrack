import SwiftUI

struct TodayRecordsSection: View {
    let intakes: [WaterIntake]
    let onDelete: (WaterIntake) -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Bugünün Kayıtları")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if intakes.isEmpty {
                Text("Henüz kayıt yok")
                    .foregroundStyle(Color("TextSecondary"))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(intakes) { intake in
                    IntakeRow(intake: intake, onDelete: { onDelete(intake) })
                }
            }
        }
        .padding()
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

struct IntakeRow: View {
    let intake: WaterIntake
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundStyle(Color("PrimaryBlue"))

            Text("\(intake.amount) ml")
                .font(.subheadline.bold())

            Spacer()

            Text(intake.timestamp, style: .time)
                .font(.caption)
                .foregroundStyle(Color("TextSecondary"))

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(Color("TextSecondary"))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TodayRecordsSection(intakes: [], onDelete: { _ in })
        .padding()
}
