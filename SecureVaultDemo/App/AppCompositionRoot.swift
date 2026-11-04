//
//  AppCompositionRoot.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import Foundation

enum AppCompositionRoot {
    static let sessionManager = SessionManager()
    static func makeLoginViewModel(onLoginSuccess: @escaping () -> Void) -> LoginViewModel {
          let repository = MockAuthenticationRepository()
          let useCase = LoginUseCase(repository: repository, sessionManager: sessionManager)
          return LoginViewModel(loginUseCase: useCase, onLoginSuccess: onLoginSuccess)
      }

      static func makeDashboardViewModel(onLogout: @escaping () -> Void) -> DashboardViewModel {
          let useCase = LogoutUseCase(sessionManager: sessionManager)
          return DashboardViewModel(logoutUseCase: useCase, onLogout: onLogout)
      }
}
