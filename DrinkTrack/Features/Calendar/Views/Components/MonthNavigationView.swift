import SwiftUI

struct MonthNavigationView: View {
    let currentMonth: Date
    let onPrevious: () -> Void
    let onNext: () -> Void

    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth).capitalized
    }

    private var canGoNext: Bool {
        let calendar = Calendar.current
        return calendar.compare(currentMonth, to: Date(), toGranularity: .month) == .orderedAscending
    }

    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }

            Spacer()

            Text(monthYearText)
                .font(.title2.bold())

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
            .disabled(!canGoNext)
            .opacity(canGoNext ? 1 : 0.3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        MonthNavigationView(
            currentMonth: Date(),
            onPrevious: {},
            onNext: {}
        )

        MonthNavigationView(
            currentMonth: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            onPrevious: {},
            onNext: {}
        )
    }
    .padding()
}
