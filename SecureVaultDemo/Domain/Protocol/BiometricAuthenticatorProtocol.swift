//
//  BiometricAuthenticatorProtocol.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//

protocol BiometricAuthenticatorProtocol {
    func canUseBiometrics() -> Bool
    func authenticate(reason: String) async throws -> Bool
}

