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
    
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    init(loginUseCase: LoginUseCase){
        self.loginUseCase = loginUseCase
    }
    
    func login() async {
        isLoading = true
        defer { isLoading=false }
        errorMessage = nil
        
        do{
            let session = try await loginUseCase.execute(email: email, password: password)
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
