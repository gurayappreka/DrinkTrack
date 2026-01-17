import SwiftUI

struct DateSelectorView: View {
    let selectedDate: Date
    let selectableDates: [Date]
    let onDateSelected: (Date) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(selectableDates, id: \.self) { date in
                    DateButton(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        action: { onDateSelected(date) }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void

    private var dayName: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Bugun"
        } else if calendar.isDateInYesterday(date) {
            return "Dun"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date).capitalized
        }
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                Text(dayNumber)
                    .font(.title2.bold())
            }
            .frame(width: 80, height: 60)
            .background(isSelected ? Color("PrimaryBlue") : Color("CardColor"))
            .foregroundStyle(isSelected ? .white : Color("TextPrimary"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
    }
}

#Preview {
    DateSelectorView(
        selectedDate: Date(),
        selectableDates: [Date(), Date().addingTimeInterval(-86400), Date().addingTimeInterval(-172800)],
        onDateSelected: { _ in }
    )
    .padding()
}
