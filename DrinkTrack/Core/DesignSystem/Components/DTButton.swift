import SwiftUI

enum DTButtonStyle {
    case primary
    case secondary
    case destructive
}

enum DTButtonSize {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 48
        case .large: return 56
        }
    }

    var fontSize: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .body
        case .large: return .headline
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }
}

struct DTButton: View {
    let title: String
    let style: DTButtonStyle
    let size: DTButtonSize
    let isFullWidth: Bool
    let isDisabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        style: DTButtonStyle = .primary,
        size: DTButtonSize = .medium,
        isFullWidth: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isFullWidth = isFullWidth
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(size.fontSize.weight(.semibold))
                    .foregroundStyle(foregroundColor)
                    .frame(maxWidth: isFullWidth ? .infinity : nil)
                    .frame(height: size.height)
                    .padding(.horizontal, isFullWidth ? 0 : size.horizontalPadding)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: style == .secondary ? 1.5 : 0)
                    )
            }
        )
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return Color("PrimaryBlue")
        case .secondary:
            return .clear
        case .destructive:
            return .red
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return Color("PrimaryBlue")
        case .destructive:
            return .white
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary:
            return .clear
        case .secondary:
            return Color("PrimaryBlue")
        case .destructive:
            return .clear
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DTButton("Primary Large", style: .primary, size: .large, action: {})
        DTButton("Primary Medium", style: .primary, size: .medium, action: {})
        DTButton("Primary Small", style: .primary, size: .small, action: {})
        DTButton("Secondary", style: .secondary, action: {})
        DTButton("Destructive", style: .destructive, action: {})
        DTButton("Full Width", style: .primary, size: .large, isFullWidth: true, action: {})
        DTButton("Disabled", style: .primary, isDisabled: true, action: {})
    }
    .padding()
}
