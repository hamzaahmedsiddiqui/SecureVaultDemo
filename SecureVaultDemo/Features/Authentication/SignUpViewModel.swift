//
//  SignUpViewModel.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-04.
//

import Foundation

@MainActor
@Observable

final class SignUpViewModel{
    private let signUpUseCase: SignUpUseCase
    private let onSignUpSuccess: () -> Void
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(useCase: SignUpUseCase, onSignUpSuccess: @escaping () -> Void) {
        self.signUpUseCase = useCase
        self.onSignUpSuccess = onSignUpSuccess
    }
    
    func signUp() async {
        guard password == confirmPassword else {
            errorMessage = "Password do not match"
            return
        }
        
        isLoading = true
        defer{ isLoading = false }
        errorMessage = nil
        
        do{
           _ = try await signUpUseCase.execute(email: email, password: password)
            onSignUpSuccess()
        }catch let error as SignUpError{
            errorMessage = message(for: error)
        }catch {
            errorMessage = "Something went wrong. Please try again"
        }
        
    }
    
    private func message(for error: SignUpError) -> String {
         switch error {
         case .emailAlreadyInUse: return "This email is already registered"
         case .weakPassword: return "Password must be at least 8 characters"
         case .networkUnavailable: return "No internet connection"
         case .serverError: return "Server error. Please try again later."
         case .unknown: return "Something went wrong. Please try again."
         }
     }
}
