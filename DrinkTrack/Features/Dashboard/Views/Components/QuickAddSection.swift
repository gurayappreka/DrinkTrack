import SwiftUI

struct QuickAddSection: View {
    let onAdd: (Int) -> Void
    @State private var showCustomInput = false

    let quickAmounts = [
        (amount: 150, label: "Küçük", icon: "cup.and.saucer"),
        (amount: 250, label: "Bardak", icon: "mug"),
        (amount: 500, label: "Şişe", icon: "waterbottle")
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Hızlı Ekle")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                ForEach(quickAmounts, id: \.amount) { item in
                    QuickAddButton(
                        amount: item.amount,
                        label: item.label,
                        icon: item.icon,
                        action: { onAdd(item.amount) }
                    )
                }

                // Custom Amount Button
                Button {
                    showCustomInput = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                        Text("Özel")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                    .padding(.vertical, 8)
                    .background(Color("CardColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                }
                .foregroundStyle(Color("TextPrimary"))
            }
        }
        .sheet(isPresented: $showCustomInput) {
            CustomAmountSheet(onAdd: onAdd)
                .presentationDetents([.height(200)])
        }
    }
}

struct QuickAddButton: View {
    let amount: Int
    let label: String
    let icon: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                Text("\(amount)ml")
                    .font(.subheadline.bold())
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color("TextSecondary"))
            }
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
            .padding(.vertical, 8)
            .background(Color("CardColor"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.07), radius: 4, y: 2)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .foregroundStyle(Color("TextPrimary"))
    }
}

#Preview {
    QuickAddSection(onAdd: { _ in })
        .padding()
}
