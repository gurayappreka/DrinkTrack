import SwiftUI

struct ContributionGridView: View {
    let monthData: [DailyProgress]
    @Binding var selectedDate: Date?

    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    let weekdays = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]

    var body: some View {
        VStack(spacing: 8) {
            // Weekday Headers
            HStack(spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundStyle(Color("TextSecondary"))
                        .frame(maxWidth: .infinity)
                }
            }

            // Day Grid
            LazyVGrid(columns: columns, spacing: 4) {
                // Leading empty cells for proper alignment
                ForEach(0..<leadingEmptyCells, id: \.self) { _ in
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                }

                // Day cells
                ForEach(monthData) { progress in
                    ContributionCell(
                        progress: progress,
                        isSelected: selectedDate.map { Calendar.current.isDate($0, inSameDayAs: progress.date) } ?? false,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDate = progress.date
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var leadingEmptyCells: Int {
        guard let firstDate = monthData.first?.date else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: firstDate)
        // Convert Sunday=1 to Monday=0 based system
        return (weekday + 5) % 7
    }
}

struct ContributionCell: View {
    let progress: DailyProgress
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(contributionColor)

                if progress.isGoalMet {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? Color("PrimaryBlue") : .clear, lineWidth: 2)
            )
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var contributionColor: Color {
        switch progress.contributionLevel {
        case 0: return Color("ContributionLevel0")
        case 1: return Color("ContributionLevel1")
        case 2: return Color("ContributionLevel2")
        case 3: return Color("ContributionLevel3")
        default: return Color("ContributionLevel4")
        }
    }
}

#Preview {
    let sampleData = (1...15).compactMap { day -> DailyProgress? in
        guard let date = Calendar.current.date(byAdding: .day, value: -day, to: Date()) else {
            return nil
        }
        return DailyProgress(
            date: date,
            totalAmount: Int.random(in: 0...2500),
            goal: 2000
        )
    }.reversed()

    return ContributionGridView(
        monthData: Array(sampleData),
        selectedDate: .constant(nil)
    )
    .padding()
}
