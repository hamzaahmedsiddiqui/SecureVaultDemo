//
//  LoginView.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import SwiftUI

struct LoginView: View {

    @Bindable var viewModel: LoginViewModel
    let onSignUpTapped: () -> Void
    let onForgetPasswordTapped: () -> Void

    @FocusState private var focusedField: Field?
    @State private var isPasswordVisible = false

    private enum Field {
        case email, password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                header

                VStack(spacing: 16) {
                    emailField
                    passwordField

                    if let errorMessage = viewModel.errorMessage {
                        errorBanner(errorMessage)
                    }

                    forgotPasswordButton
                }

                VStack(spacing: 20) {
                    loginButton
                    signUpPrompt
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
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 44))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("Welcome back")
                .font(.title.bold())

            Text("Log in to continue to SecureVault")
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

            Group {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                } else {
                    SecureField("Password", text: $viewModel.password)
                }
            }
            .textContentType(.password)
            .focused($focusedField, equals: .password)
            .submitLabel(.go)
            .onSubmit { Task { await viewModel.login() } }

            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .password ? Color.accentColor : .clear, lineWidth: 1.5)
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
        .transition(.opacity.combined(with: .move(edge: .top)))
        .animation(.default, value: message)
    }

    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: onForgetPasswordTapped) {
                Text("Forgot password?")
                    .font(.footnote.weight(.medium))
            }
        }
    }

    private var loginButton: some View {
        Button {
            Task { await viewModel.login() }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Log In").font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
    }

    private var signUpPrompt: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?").foregroundStyle(.secondary)
            Button(action: onSignUpTapped) {
                Text("Sign Up").fontWeight(.semibold)
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    LoginView(
        viewModel: AppCompositionRoot.makeLoginViewModel(onLoginSuccess: {}),
        onSignUpTapped: {},
        onForgetPasswordTapped: {}
    )
}
