//
//  LoginViewModel.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import Foundation

@MainActor
@Observable

final class LoginViewModel {
    private let loginUseCase: LoginUseCase
    private let onLoginSuccess: () -> Void
    
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    init(loginUseCase: LoginUseCase, onLoginSuccess: @escaping () -> Void){
        self.loginUseCase = loginUseCase
        self.onLoginSuccess = onLoginSuccess
    }
    
    func login() async {
        isLoading = true
        defer { isLoading=false }
        errorMessage = nil
        
        do{
            let _ = try await loginUseCase.execute(email: email, password: password)
            onLoginSuccess()
    
        } catch let error as LoginError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = "Something went wrong. Please try again"
        }
    
    }
    
    private func message(for error: LoginError) -> String{
        switch error {
        case .invalidCredentials: return "Incorrect email or password"
        case .networkUnabailable: return "No internet connection"
        case .serverError: return "Server error. Please try again later."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
