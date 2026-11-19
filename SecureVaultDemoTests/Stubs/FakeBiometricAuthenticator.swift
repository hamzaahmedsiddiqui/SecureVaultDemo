//
//  MockBiometricAuthenticator.swift
//  SecureVaultDemoTests
//
//  Created by hamza Ahmed on 2026-11-18.
//

import Foundation
@testable import SecureVaultDemo

nonisolated final class FakeBiometricAuthenticator: BiometricAuthenticatorProtocol{
    var canUseBiometricsResult = true
    var authenticateResult: Result<Bool, Error> = .success(true)
    
    func canUseBiometrics() -> Bool {
        canUseBiometricsResult
    }
    
    func authenticate(reason: String) async throws -> Bool {
        try authenticateResult.get()
    }
}
