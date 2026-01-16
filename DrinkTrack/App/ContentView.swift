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

#Preview {
    ContentView()
}
