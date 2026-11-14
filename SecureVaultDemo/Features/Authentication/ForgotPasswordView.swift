import SwiftUI

struct ForgotPasswordView: View {
    @Bindable var viewModel: ForgotPasswordViewModel
    let onBackToLogin: () -> Void

    @FocusState private var isEmailFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if viewModel.didSendResetEmail {
                    confirmationView
                } else {
                    header
                    form
                }

                backToLoginButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 40)
            .frame(maxWidth: 420)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground))
        .onTapGesture { isEmailFocused = false }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "key.horizontal")
                .font(.system(size: 44))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("Reset your password")
                .font(.title.bold())

            Text("Enter your email and we'll send you a link to reset your password")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var form: some View {
        VStack(spacing: 16) {
            emailField

            if let errorMessage = viewModel.errorMessage {
                errorBanner(errorMessage)
            }

            submitButton
        }
    }

    private var emailField: some View {
        HStack(spacing: 10) {
            Image(systemName: "envelope")
                .foregroundStyle(.secondary)
                .frame(width: 20)

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isEmailFocused)
                .submitLabel(.send)
                .onSubmit { Task { await viewModel.submit() } }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isEmailFocused ? Color.accentColor : .clear, lineWidth: 1.5)
        )
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message).font(.footnote)
        }
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var submitButton: some View {
        Button {
            Task { await viewModel.submit() }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Send Reset Link").font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isLoading || viewModel.email.isEmpty)
    }

    private var confirmationView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.green)

            Text("Check your email")
                .font(.title.bold())

            Text("If an account exists for this email, a reset link has been sent.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var backToLoginButton: some View {
        Button(action: onBackToLogin) {
            Text("Back to Login")
                .font(.subheadline.weight(.semibold))
        }
    }
}

#Preview {
    ForgotPasswordView(
        viewModel: AppCompositionRoot.makeForgotPasswordViewModel(),
        onBackToLogin: {}
    )
}
