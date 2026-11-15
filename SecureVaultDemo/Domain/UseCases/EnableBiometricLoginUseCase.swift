//
//  EnableBiometricLoginUseCaseProtocol.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-15.
//


// Domain/Protocol
protocol EnableBiometricLoginUseCaseProtocol {
    mutating func execute() async throws -> Bool
}

// Domain/UseCases
struct EnableBiometricLoginUseCase: EnableBiometricLoginUseCaseProtocol {

    
    private let biometricAuthenticator: BiometricAuthenticatorProtocol
    private var biometricPreference: BiometricPreferenceStoringProtocol

    init(biometricAuthenticator: BiometricAuthenticatorProtocol, biometricPreference: BiometricPreferenceStoringProtocol) {
        self.biometricAuthenticator = biometricAuthenticator
        self.biometricPreference = biometricPreference
    }

    mutating func execute() async throws -> Bool {
        guard biometricAuthenticator.canUseBiometrics() else {
            return false
        }
        let success = try await biometricAuthenticator.authenticate(reason: "Enable Face ID for faster sign-in")
        if success {
            biometricPreference.isEnabled = true
        }
        return success
    }
}
