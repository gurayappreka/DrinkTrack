import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var settings: [UserSettings]

    var body: some View {
        if let userSettings = settings.first, userSettings.hasCompletedOnboarding {
            DashboardView()
        } else {
            OnboardingView()
        }
    }
}

// MARK: - Placeholder Dashboard View
struct DashboardView: View {
    var body: some View {
        VStack {
            Image(systemName: "drop.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("DrinkTrack Dashboard")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
