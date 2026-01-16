import SwiftUI

struct ContributionLegendView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Az")
                .font(.caption2)
                .foregroundStyle(Color("TextSecondary"))

            ForEach(0..<5, id: \.self) { level in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color("ContributionLevel\(level)"))
                    .frame(width: 12, height: 12)
            }

            Text("Çok")
                .font(.caption2)
                .foregroundStyle(Color("TextSecondary"))
        }
    }
}

#Preview {
    ContributionLegendView()
        .padding()
        .background(Color("BackgroundColor"))
}
