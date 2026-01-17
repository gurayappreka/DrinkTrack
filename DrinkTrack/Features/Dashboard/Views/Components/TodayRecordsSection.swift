import SwiftUI

struct TodayRecordsSection: View {
    let intakes: [WaterIntake]
    let onDelete: (WaterIntake) -> Void

    var body: some View {
        DayRecordsSection(
            intakes: intakes,
            dateLabel: "Bugun",
            canDelete: true,
            onDelete: onDelete
        )
    }
}

struct DayRecordsSection: View {
    let intakes: [WaterIntake]
    let dateLabel: String
    let canDelete: Bool
    let onDelete: (WaterIntake) -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("\(dateLabel) - Kayitlar")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if intakes.isEmpty {
                Text("Henuz kayit yok")
                    .foregroundStyle(Color("TextSecondary"))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(intakes) { intake in
                    IntakeRow(
                        intake: intake,
                        showDelete: canDelete,
                        onDelete: { onDelete(intake) }
                    )
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
    var showDelete: Bool = true
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

            if showDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color("TextSecondary"))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TodayRecordsSection(intakes: [], onDelete: { _ in })
        .padding()
}
