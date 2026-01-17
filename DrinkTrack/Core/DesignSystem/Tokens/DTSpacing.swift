import SwiftUI

/// Design System Spacing Tokens
/// Tutarlı boşluk değerleri için merkezi tanımlar
enum DTSpacing {
    // MARK: - Base Spacing
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32

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
