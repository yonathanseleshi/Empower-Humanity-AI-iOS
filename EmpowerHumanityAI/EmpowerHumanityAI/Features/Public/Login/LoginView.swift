import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var navigateToSignup = false
    @State private var showForgotPassword = false

    var body: some View {
        ScrollView {
            VStack(spacing: EHSpacing.xl) {
                // Header
                VStack(spacing: EHSpacing.sm) {
                    CoIntelligenceOrb(state: .available, size: 60)
                    Text("Welcome back")
                        .font(EHTypography.h2)
                        .foregroundStyle(EHColors.Text.primary)
                    Text("Sign in to continue with Alex")
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.muted)
                }
                .padding(.top, EHSpacing.xxxl)

                // Form
                VStack(spacing: EHSpacing.md) {
                    EHFormField(label: "Email", placeholder: "you@example.com", text: $email, keyboardType: .emailAddress)
                    EHFormField(label: "Password", placeholder: "Password", text: $password, isSecure: true)
                }

                // Error
                if let errorMessage {
                    Text(errorMessage)
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.red)
                        .multilineTextAlignment(.center)
                }

                // Sign In
                EHPrimaryButton("Sign In", isLoading: isLoading) {
                    Task { await signIn() }
                }

                // Google (placeholder)
                Button {
                    // Future: Sign in with Google OAuth
                } label: {
                    HStack(spacing: EHSpacing.xs) {
                        Image(systemName: "globe")
                        Text("Continue with Google")
                    }
                    .font(EHTypography.buttonLabel)
                    .foregroundStyle(EHColors.Text.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, EHSpacing.md)
                    .background(EHColors.white)
                    .clipShape(RoundedRectangle(cornerRadius: EHRadius.pill))
                    .overlay(
                        RoundedRectangle(cornerRadius: EHRadius.pill)
                            .strokeBorder(EHColors.border, lineWidth: 1)
                    )
                }

                // Forgot password
                Button("Forgot password?") {
                    showForgotPassword = true
                }
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.trustBlue)

                EHDivider()

                // Create account
                HStack {
                    Text("Don't have an account?")
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.muted)
                    Button("Create one") { navigateToSignup = true }
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.trustBlue)
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.bottom, EHSpacing.section)
        }
        .background(EHColors.page)
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToSignup) {
            SignupView()
        }
        .alert("Forgot Password", isPresented: $showForgotPassword) {
            Button("OK") {}
        } message: {
            Text("Password reset via email will be available once the backend is connected.")
        }
    }

    private func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }
        isLoading = true
        errorMessage = nil
        await appState.signIn(email: email, password: password)
        isLoading = false
    }
}
