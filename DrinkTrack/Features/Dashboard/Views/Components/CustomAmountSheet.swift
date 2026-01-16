import SwiftUI

struct CustomAmountSheet: View {
    let onAdd: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var customAmount: Int?

    var body: some View {
        VStack(spacing: 20) {
            Text("Özel Miktar")
                .font(.headline)

            HStack {
                TextField("Miktar", value: $customAmount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)

                Text("ml")
                    .foregroundStyle(Color("TextSecondary"))
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                Button("İptal") {
                    dismiss()
                }
                .buttonStyle(.bordered)

                Button("Ekle") {
                    if let amount = customAmount, amount > 0 {
                        onAdd(amount)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(customAmount == nil || customAmount! <= 0)
            }
        }
        .padding()
    }
}

#Preview {
    CustomAmountSheet(onAdd: { _ in })
}
