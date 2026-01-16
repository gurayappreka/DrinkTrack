import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "gearshape")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ayarlar")
        }
        .padding()
        .navigationTitle("Ayarlar")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
