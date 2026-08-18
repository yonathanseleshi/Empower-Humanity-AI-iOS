import SwiftUI

struct SignupView: View {
    @Environment(AppState.self) private var appState
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: EHSpacing.xl) {
                // Header
                VStack(spacing: EHSpacing.sm) {
                    CoIntelligenceOrb(state: .available, size: 60)
                    Text("Create your account")
                        .font(EHTypography.h2)
                        .foregroundStyle(EHColors.Text.primary)
                    Text("Meet your co-intelligence")
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.muted)
                }
                .padding(.top, EHSpacing.xxxl)

                // Form
                VStack(spacing: EHSpacing.md) {
                    EHFormField(label: "Full name", placeholder: "Your name", text: $name)
                    EHFormField(label: "Email", placeholder: "you@example.com", text: $email, keyboardType: .emailAddress)
                    EHFormField(label: "Password", placeholder: "Create a password", text: $password, isSecure: true)
                    EHFormField(label: "Confirm password", placeholder: "Confirm your password", text: $confirmPassword, isSecure: true)
                }

                // Terms
                Button {
                    agreedToTerms.toggle()
                } label: {
                    HStack(spacing: EHSpacing.xs) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            .foregroundStyle(agreedToTerms ? EHColors.trustBlue : EHColors.Text.subtle)
                        Text("I agree to the Terms of Service and Privacy Policy")
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.secondary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }

                // Error
                if let errorMessage {
                    Text(errorMessage)
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.red)
                        .multilineTextAlignment(.center)
                }

                EHPrimaryButton("Create Account", isLoading: isLoading) {
                    Task { await createAccount() }
                }
                .disabled(!agreedToTerms)
                .opacity(agreedToTerms ? 1 : 0.5)
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.bottom, EHSpacing.section)
        }
        .background(EHColors.page)
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func createAccount() async {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard agreedToTerms else {
            errorMessage = "Please agree to the terms."
            return
        }
        isLoading = true
        errorMessage = nil
        let tier = await appState.signUp(name: name, email: email, password: password)
        isLoading = false
        if !tier.hasFullAccess {
            // App state is already set, navigation will route to AccessStatusView if needed
        }
    }
}
