//
//  ForgotPasswordView.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-05.
//


import SwiftUI

struct ForgotPasswordView: View {
    @Bindable var viewModel: ForgotPasswordViewModel
    let onBackToLogin: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.didSendResetEmail {
                Text("If an account exists for this email, a reset link has been sent.")
                    .multilineTextAlignment(.center)
            } else {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                Button {
                    Task {
                        await viewModel.submit()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Send Reset Link")
                    }
                }
                .disabled(viewModel.isLoading)
            }

            Button("Back to Login") {
                onBackToLogin()
            }
        }
        .padding()
    }
}

#Preview {
    ForgotPasswordView(
        viewModel: AppCompositionRoot.makeForgotPasswordViewModel(),
        onBackToLogin: {}
    )
}