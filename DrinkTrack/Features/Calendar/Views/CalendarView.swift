import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Takvim")
        }
        .padding()
        .navigationTitle("Takvim")
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
