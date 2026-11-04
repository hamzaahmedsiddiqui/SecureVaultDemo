//
//  AppCompositionRoot.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import Foundation

enum AppCompositionRoot {
    static let sessionManager = SessionManager()
    static let repository = MockAuthenticationRepository()
    
    static func makeLoginViewModel(onLoginSuccess: @escaping () -> Void) -> LoginViewModel {
          let useCase = LoginUseCase(repository: repository, sessionManager: sessionManager)
          return LoginViewModel(loginUseCase: useCase, onLoginSuccess: onLoginSuccess)
      }

      static func makeDashboardViewModel(onLogout: @escaping () -> Void) -> DashboardViewModel {
          let useCase = LogoutUseCase(sessionManager: sessionManager)
          return DashboardViewModel(logoutUseCase: useCase, onLogout: onLogout)
      }
    
    static func makeSignUpViewModel(onSignUpSuccess: @escaping () -> Void) -> SignUpViewModel{
        
        let useCase = SignUpUseCase(repository: repository, sessionManager: sessionManager)
        return SignUpViewModel(useCase: useCase, onSignUpSuccess: onSignUpSuccess)
    }
}
