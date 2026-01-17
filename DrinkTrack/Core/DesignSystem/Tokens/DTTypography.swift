import SwiftUI

/// Design System Typography Tokens
/// Tutarlı text stilleri için merkezi tanımlar
enum DTTypography {
    // MARK: - Section Titles
    /// Section başlıkları için stil (örn: "Hedef Ayarları", "İstatistikler")
    static let sectionTitle = Font.subheadline.weight(.semibold)

    // MARK: - Card Content
    /// Card içindeki ana metin
    static let cardTitle = Font.body

    /// Card içindeki değer metni
    static let cardValue = Font.body.weight(.medium)

    /// Card içindeki ikincil metin
    static let cardCaption = Font.caption

    // MARK: - Colors
    /// Ana metin rengi
    static let primaryColor = Color("TextPrimary")

    /// İkincil metin rengi - daha belirgin
    static let secondaryColor = Color("TextPrimary").opacity(0.7)

    /// Soluk metin rengi - caption'lar için
    static let tertiaryColor = Color("TextSecondary")
}

// MARK: - View Modifiers
extension View {
    /// Section başlığı stili
    func dtSectionTitle() -> some View {
        self
            .font(DTTypography.sectionTitle)
            .foregroundStyle(DTTypography.primaryColor)
    }

    /// Card ana metin stili
    func dtCardTitle() -> some View {
        self
            .font(DTTypography.cardTitle)
            .foregroundStyle(DTTypography.primaryColor)
    }

    /// Card değer stili
    func dtCardValue() -> some View {
        self
            .font(DTTypography.cardValue)
            .foregroundStyle(DTTypography.primaryColor)
    }

    /// Card caption stili
    func dtCardCaption() -> some View {
        self
            .font(DTTypography.cardCaption)
            .foregroundStyle(DTTypography.tertiaryColor)
    }
}
