import SwiftUI

// MARK: - EHPrimaryButton

struct EHPrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    init(_ title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: EHSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(EHTypography.buttonLabel)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, EHSpacing.md)
            .background(EHColors.trustBlue)
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.pill))
        }
        .disabled(isLoading)
    }
}

// MARK: - EHSecondaryButton

struct EHSecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(EHTypography.buttonLabel)
                .foregroundStyle(EHColors.trustBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, EHSpacing.md)
                .background(EHColors.white)
                .clipShape(RoundedRectangle(cornerRadius: EHRadius.pill))
                .overlay(
                    RoundedRectangle(cornerRadius: EHRadius.pill)
                        .strokeBorder(EHColors.border, lineWidth: 1)
                )
        }
    }
}

// MARK: - EHStatusBadge

struct EHStatusBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(EHTypography.micro)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - EHIconContainer

struct EHIconContainer: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 36

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.45, weight: .medium))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.sm))
    }
}

// MARK: - EHSectionHeader

struct EHSectionHeader: View {
    let title: String
    var trailing: String? = nil
    var trailingAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(EHTypography.h4)
                .foregroundStyle(EHColors.Text.primary)
            Spacer()
            if let trailing = trailing {
                Button(trailing) { trailingAction?() }
                    .font(EHTypography.label)
                    .foregroundStyle(EHColors.trustBlue)
            }
        }
    }
}

// MARK: - EHEmptyState

struct EHEmptyState: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: EHSpacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(EHColors.Text.subtle)

            VStack(spacing: EHSpacing.xs) {
                Text(title)
                    .font(EHTypography.h4)
                    .foregroundStyle(EHColors.Text.primary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.muted)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .font(EHTypography.buttonLabel)
                    .foregroundStyle(EHColors.trustBlue)
            }
        }
        .padding(EHSpacing.xxl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - EHLoadingView

struct EHLoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: EHSpacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(EHColors.trustBlue)
            Text(message)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.muted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - EHDivider

struct EHDivider: View {
    var body: some View {
        Divider()
            .background(EHColors.border)
    }
}

// MARK: - EHFormField

struct EHFormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.xxs) {
            Text(label)
                .font(EHTypography.label)
                .foregroundStyle(EHColors.Text.secondary)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .font(EHTypography.bodyMd)
            .foregroundStyle(EHColors.Text.primary)
            .padding(EHSpacing.sm)
            .background(EHColors.white)
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: EHRadius.md)
                    .strokeBorder(EHColors.border, lineWidth: 1)
            )
        }
    }
}
