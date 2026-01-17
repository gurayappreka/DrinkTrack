import SwiftUI

struct DTBottomSheet<Content: View>: View {
    let title: String
    let onClose: () -> Void
    let content: Content

    init(
        title: String,
        onClose: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.onClose = onClose
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("TextPrimary"))

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundStyle(Color("TextSecondary"))
                        .frame(width: 32, height: 32)
                        .background(Color("BackgroundColor"))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)

            // Content
            content
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .background(Color("CardColor"))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24
            )
        )
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor")
            .ignoresSafeArea()

        VStack {
            Spacer()
            DTBottomSheet(title: "Ozel Miktar", onClose: {}) {
                VStack(spacing: 24) {
                    DTTextField("Miktar", value: .constant(250), suffix: "ml")
                    DTButton("Ekle", style: .primary, size: .large, isFullWidth: true) {}
                }
            }
        }
    }
}
