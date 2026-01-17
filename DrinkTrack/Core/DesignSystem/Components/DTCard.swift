import SwiftUI

struct DTCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DTSpacing.cardPadding)
            .background(Color("CardColor"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct DTCardRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String?
    let showChevron: Bool
    let action: (() -> Void)?

    init(
        icon: String,
        iconColor: Color = Color("PrimaryBlue"),
        title: String,
        value: String? = nil,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.showChevron = showChevron
        self.action = action
    }

    var body: some View {
        Button(
            action: { action?() },
            label: {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(iconColor)
                        .frame(width: 28)

                    Text(title)
                        .dtCardTitle()

                    Spacer()

                    if let value = value {
                        Text(value)
                            .dtCardValue()
                    }

                    if showChevron {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
                .frame(minHeight: DTSpacing.cardRowHeight)
                .contentShape(Rectangle())
            }
        )
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

struct DTCardSection: View {
    let title: String?
    let rows: [DTCardRowData]

    init(title: String? = nil, rows: [DTCardRowData]) {
        self.title = title
        self.rows = rows
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DTSpacing.sectionTitleSpacing) {
            if let title = title {
                Text(title)
                    .dtSectionTitle()
                    .padding(.horizontal, 4)
            }

            DTCard(
                content: {
                    VStack(spacing: DTSpacing.statsItemSpacing) {
                        ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                            VStack(spacing: DTSpacing.statsItemSpacing) {
                                DTCardRow(
                                    icon: row.icon,
                                    iconColor: row.iconColor,
                                    title: row.title,
                                    value: row.value,
                                    showChevron: row.showChevron,
                                    action: row.action
                                )

                                if index < rows.count - 1 {
                                    Divider()
                                        .padding(.leading, 44)
                                }
                            }
                        }
                    }
                }
            )
        }
    }
}

struct DTCardRowData: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let value: String?
    let showChevron: Bool
    let action: (() -> Void)?

    init(
        icon: String,
        iconColor: Color = Color("PrimaryBlue"),
        title: String,
        value: String? = nil,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.showChevron = showChevron
        self.action = action
    }
}

#Preview {
    VStack(spacing: 24) {
        DTCardSection(
            title: "Istatistikler",
            rows: [
                DTCardRowData(icon: "drop.fill", title: "Toplam Kayit", value: "156"),
                DTCardRowData(icon: "flame.fill", iconColor: .orange, title: "En Uzun Seri", value: "12 gun"),
                DTCardRowData(icon: "chart.bar.fill", title: "Ortalama Gunluk", value: "1850 ml")
            ]
        )

        DTCardSection(
            title: "Hakkinda",
            rows: [
                DTCardRowData(icon: "info.circle", title: "Versiyon", value: "1.0.0")
            ]
        )
    }
    .padding()
    .background(Color("BackgroundColor"))
}
