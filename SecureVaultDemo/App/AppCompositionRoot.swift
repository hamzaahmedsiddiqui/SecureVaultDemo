//
//  AppCompositionRoot.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import Foundation

enum AppCompositionRoot {
    static let sessionManager = SessionManager(keychainService: KeychainService() as KeychainServiceProtocol)
    static let repository = FirebaseAuthenticationRepository(httpClient: URLSessionHTTPClient())
    static let biometricAuthenticator = BiometricAuthenticator()
    static let biometricPreference = BiometricPreferenceStoring()
    
    static func makeLoginViewModel(onLoginSuccess: @escaping () -> Void) -> LoginViewModel {
        let loginUseCase = LoginUseCase(repository: repository, sessionManager: sessionManager)
        let enableBiometricUseCase = EnableBiometricLoginUseCase(biometricAuthenticator: biometricAuthenticator, biometricPreference: biometricPreference)
        return LoginViewModel(loginUseCase: loginUseCase,enableBiometricLoginUseCase: enableBiometricUseCase, onLoginSuccess: onLoginSuccess)
    }
    
    static func makeDashboardViewModel(onLogout: @escaping () -> Void) -> DashboardViewModel {
        let useCase = LogoutUseCase(sessionManager: sessionManager, biometricPreference: biometricPreference)
        return DashboardViewModel(logoutUseCase: useCase, onLogout: onLogout)
    }
    
    static func makeSignUpViewModel(onSignUpSuccess: @escaping () -> Void) -> SignUpViewModel{
        
        let useCase = SignUpUseCase(repository: repository, sessionManager: sessionManager)
        return SignUpViewModel(useCase: useCase, onSignUpSuccess: onSignUpSuccess)
    }
    
    static func makeForgotPasswordViewModel() -> ForgotPasswordViewModel {
        let useCase = ForgotPasswordUseCase(repository: repository)
        return ForgotPasswordViewModel(forgotPasswordUseCase: useCase)
    }
    
    static func makeRestoreSessionUseCase() -> RestoreSessionUseCaseProtocol{
        RestoreSessionUseCase(sessionManager: sessionManager, biometricAuthenticator: biometricAuthenticator, biometricPreference: biometricPreference)
    }
    
    static func makeAppStateViewMode() -> AppStateViewModel {
        AppStateViewModel(authState: .checking, restoreSessionUseCase: makeRestoreSessionUseCase())
    }
    
}
