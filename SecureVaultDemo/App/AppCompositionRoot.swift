//
//  AppCompositionRoot.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-02.
//

import Foundation

enum AppCompositionRoot {
    static func makeLoginViewModel() -> LoginViewModel{
        let repository = MockAuthenticationRepository()
        let useCase = LoginUseCase(repository: repository)
        return LoginViewModel(loginUseCase: useCase)
    }
}
