//
//  EnableBiometricLoginUseCaseTest.swift
//  SecureVaultDemoTests
//
//  Created by hamza Ahmed on 2026-11-18.
//

import Testing
@testable import SecureVaultDemo

struct EnableBiometricLoginUseCaseTests {
    let authenticator = FakeBiometricAuthenticator()
    let preference = FakeBiometricPreferenceStoring()
    let sut: EnableBiometricLoginUseCase
    
    init() {
        self.sut = EnableBiometricLoginUseCase(biometricAuthenticator: authenticator, biometricPreference: preference)
    }
    
    @Test("Enableing biometrics succeeds and turn the preference on")
    func execute_whenBiometricsSucceed_enablesPreference() async throws {
        //GIVEN
        authenticator.canUseBiometricsResult = true
        authenticator.authenticateResult = .success(true)
        
        //WHEN
        let result = try await sut.execute()
        
        //THEN
        #expect(result == true)
        #expect(preference.isEnabled == true)
    }
    
    @Test("User cancelling biometrics does not enable the preference")
     func execute_whenUserCancels_doesNotEnablePreference() async throws {
         authenticator.canUseBiometricsResult = true
         authenticator.authenticateResult = .success(false)

         let result = try await sut.execute()

         #expect(result == false)
         #expect(preference.isEnabled == false)
     }
}
