import SwiftUI

struct SignUpView: View {

    @Bindable var viewModel: SignUpViewModel
    let onLoginTapped: () -> Void

    @FocusState private var focusedField: Field?
    @State private var isPasswordVisible = false

    private enum Field {
        case email, password, confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                header

                VStack(spacing: 16) {
                    emailField
                    passwordField
                    confirmPasswordField
                    passwordsMismatchHint

                    if let errorMessage = viewModel.errorMessage {
                        errorBanner(errorMessage)
                    }
                }

                VStack(spacing: 20) {
                    signUpButton
                    loginPrompt
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 40)
            .frame(maxWidth: 420)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground))
        .onTapGesture { focusedField = nil }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 44))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("Create your account")
                .font(.title.bold())

            Text("Sign up to get started with SecureVault")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .email ? Color.accentColor : .clear, lineWidth: 1.5)
        )
    }

    private var passwordField: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .foregroundStyle(.secondary)
                .frame(width: 20)

            passwordOrTextField(text: $viewModel.password, placeholder: "Password")
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .confirmPassword }

            visibilityToggleButton
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .password ? Color.accentColor : .clear, lineWidth: 1.5)
        )
    }

    private var confirmPasswordField: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .foregroundStyle(.secondary)
                .frame(width: 20)

            passwordOrTextField(text: $viewModel.confirmPassword, placeholder: "Confirm Password")
                .textContentType(.newPassword)
                .focused($focusedField, equals: .confirmPassword)
                .submitLabel(.go)
                .onSubmit { Task { await viewModel.signUp() } }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .confirmPassword ? Color.accentColor : .clear, lineWidth: 1.5)
        )
    }

    @ViewBuilder
    private func passwordOrTextField(text: Binding<String>, placeholder: String) -> some View {
        if isPasswordVisible {
            TextField(placeholder, text: text)
        } else {
            SecureField(placeholder, text: text)
        }
    }

    private var visibilityToggleButton: some View {
        Button {
            isPasswordVisible.toggle()
        } label: {
            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
    }

    @ViewBuilder
    private var passwordsMismatchHint: some View {
        if !viewModel.confirmPassword.isEmpty && viewModel.password != viewModel.confirmPassword {
            HStack {
                Text("Passwords don't match")
                    .font(.footnote)
                    .foregroundStyle(.red)
                Spacer()
            }
        }
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

    private var signUpButton: some View {
        Button {
            Task { await viewModel.signUp() }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Sign Up").font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(
            viewModel.isLoading
            || viewModel.email.isEmpty
            || viewModel.password.isEmpty
            || viewModel.password != viewModel.confirmPassword
        )
    }

    private var loginPrompt: some View {
        HStack(spacing: 4) {
            Text("Already have an account?").foregroundStyle(.secondary)
            Button(action: onLoginTapped) {
                Text("Log In").fontWeight(.semibold)
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    SignUpView(viewModel: AppCompositionRoot.makeSignUpViewModel {}, onLoginTapped: {})
}
