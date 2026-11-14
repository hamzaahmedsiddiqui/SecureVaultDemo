//
//  BiometricAuthenticator.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-09-14.
//

import Foundation
import LocalAuthentication

struct BiometricAuthenticator: BiometricAuthenticatorProtocol {
    func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error {
                print("Biometric unavailable: \(error.localizedDescription)")
            }
            throw BiometricsError.notAvailable
        }
        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        } catch {
            throw BiometricsError.authenticationFailed(error)
        }
    }
    
    
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
