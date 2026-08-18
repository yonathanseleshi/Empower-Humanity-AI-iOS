import Foundation
import SwiftUI

// MARK: - Date Extensions

extension Date {
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    var mediumDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    var dayLabel: String {
        if isToday { return "Today" }
        if isTomorrow { return "Tomorrow" }
        return mediumDateString
    }
}

// MARK: - String Extensions

extension String {
    var initials: String {
        let words = components(separatedBy: " ")
        let letters = words.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

// MARK: - View Extensions

extension View {
    func ehCard(level: Int = 1) -> some View {
        self
            .background(EHColors.Surface.level(level))
            .clipShape(RoundedRectangle(cornerRadius: level == 2 ? EHRadius.lg : EHRadius.md))
            .shadow(
                color: level == 2 ? Color.black.opacity(0.06) : Color.clear,
                radius: level == 2 ? 8 : 0,
                y: level == 2 ? 2 : 0
            )
            .overlay(
                RoundedRectangle(cornerRadius: level == 2 ? EHRadius.lg : EHRadius.md)
                    .strokeBorder(
                        level == 2 ? EHColors.border.opacity(0.5) : EHColors.border,
                        lineWidth: 1
                    )
            )
    }

    func ehSection(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            Text(title.uppercased())
                .font(EHTypography.label)
                .foregroundStyle(EHColors.Text.muted)
                .padding(.horizontal, EHSpacing.md)
            self
        }
    }

    func conditionalHidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }
}

// MARK: - Color Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
