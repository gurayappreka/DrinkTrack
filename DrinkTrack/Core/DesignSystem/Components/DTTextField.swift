import SwiftUI

struct DTTextField: View {
    let placeholder: String
    @Binding var value: Int?
    let suffix: String?

    init(
        _ placeholder: String,
        value: Binding<Int?>,
        suffix: String? = nil
    ) {
        self.placeholder = placeholder
        self._value = value
        self.suffix = suffix
    }

    var body: some View {
        HStack(spacing: 12) {
            TextField(placeholder, value: $value, format: .number)
                .font(.title2)
                .keyboardType(.numberPad)
                .multilineTextAlignment(suffix != nil ? .trailing : .leading)

            if let suffix = suffix {
                Text(suffix)
                    .font(.title3)
                    .foregroundStyle(Color("TextSecondary"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("PrimaryBlue").opacity(0.3), lineWidth: 1.5)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        DTTextField("Miktar", value: .constant(250), suffix: "ml")
        DTTextField("Miktar", value: .constant(nil), suffix: "ml")
    }
    .padding()
    .background(Color("BackgroundColor"))
}
