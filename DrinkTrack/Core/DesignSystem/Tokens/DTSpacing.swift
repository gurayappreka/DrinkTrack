import SwiftUI

/// Design System Spacing Tokens
/// Tutarlı boşluk değerleri için merkezi tanımlar
enum DTSpacing {
    // MARK: - Base Spacing
    static let extraExtraSmall: CGFloat = 4
    static let extraSmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 20
    static let extraLarge: CGFloat = 24
    static let extraExtraLarge: CGFloat = 32

    // MARK: - Component Specific
    /// Card içi padding
    static let cardPadding: CGFloat = 16

    /// Card row minimum yüksekliği
    static let cardRowHeight: CGFloat = 44

    /// Section başlık ile içerik arası
    static let sectionTitleSpacing: CGFloat = 8

    /// Section'lar arası boşluk
    static let sectionSpacing: CGFloat = 24

    /// Card row'ları arasında divider ile birlikte toplam boşluk
    static let cardRowSpacing: CGFloat = 0

    /// İstatistik card'larındaki item'lar arası boşluk
    static let statsItemSpacing: CGFloat = 12
}
