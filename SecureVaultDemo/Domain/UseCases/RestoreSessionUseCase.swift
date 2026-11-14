//
//  RestoreSessionUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//
import Foundation

protocol RestoreSessionUseCaseProtocol {
    func execute() async throws -> Bool
}



struct RestoreSessionUseCase: RestoreSessionUseCaseProtocol{
    private let sessionManager: SessionManager
    private let biometricAuthenticator: BiometricAuthenticatorProtocol
    private let biometricPreference: BiometricPreferenceStoring
    
    init(sessionManager: SessionManager, biometricAuthenticator: BiometricAuthenticatorProtocol, biometricPreference: BiometricPreferenceStoring) {
        self.sessionManager = sessionManager
        self.biometricAuthenticator = biometricAuthenticator
        self.biometricPreference = biometricPreference
    }
    
    func execute() async throws -> Bool {
        guard try await sessionManager.hasSavedSession() else { return false }
        if biometricPreference.isEnabled {
            guard try await biometricAuthenticator.authenticate(reason: "Log in to SecureVault") else {
                return false
            }
        }
        return try await sessionManager.restoreSession()
    }
    
}
