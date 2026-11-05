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

    var body: some View {
        VStack(spacing: 16){
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
            Button{
                Task{
                    await viewModel.login()
                }
            } label: {
                if viewModel.isLoading{
                    ProgressView()
                } else {
                    Text("Log In")
                }
            }
            .disabled(viewModel.isLoading)
            Button("Don't have an account?"){
                onSignUpTapped()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: AppCompositionRoot.makeLoginViewModel(onLoginSuccess: {}), onSignUpTapped: {})
}
