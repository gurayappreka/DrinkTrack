import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "drop.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("DrinkTrack")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
