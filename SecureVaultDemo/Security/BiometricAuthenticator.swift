//
//  BiometricAuthenticator.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-09-14.
//

import Foundation
import LocalAuthentication

protocol BiometricAuthenticatorProtocol {
    func canUseBiometrics() -> Bool
    func authenticate(reason: String) async throws -> Bool
}

enum BiometricsError: Error{
    case notAvailable
    case authenticationFailed(Error)
}

struct BiometricAuthenticator: BiometricAuthenticatorProtocol {
    
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
