import SwiftUI

struct CustomAmountSheet: View {
    let onAdd: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var customAmount: Int?

    var body: some View {
        DTBottomSheet(title: "Ozel Miktar", onClose: { dismiss() }) {
            VStack(spacing: 24) {
                DTTextField("Miktar girin", value: $customAmount, suffix: "ml")

                DTButton(
                    "Ekle",
                    style: .primary,
                    size: .large,
                    isFullWidth: true,
                    isDisabled: (customAmount ?? 0) <= 0
                ) {
                    if let amount = customAmount, amount > 0 {
                        onAdd(amount)
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(220)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            CustomAmountSheet(onAdd: { _ in })
        }
}
