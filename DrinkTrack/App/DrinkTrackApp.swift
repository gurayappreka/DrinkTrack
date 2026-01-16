import SwiftUI
import SwiftData

@main
struct DrinkTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [WaterIntake.self, UserSettings.self])
    }
}
