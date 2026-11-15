//
//  LogoutUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//

struct LogoutUseCase {
    let sessionManager: SessionManager
    private let biometricPreference: BiometricPreferenceStoringProtocol
    
    init(sessionManager: SessionManager, biometricPreference: BiometricPreferenceStoringProtocol) {
        self.sessionManager = sessionManager
        self.biometricPreference = biometricPreference
    }

    func execute() async throws{
        biometricPreference.isEnabled = false
        try await sessionManager.clear()
    }
}
