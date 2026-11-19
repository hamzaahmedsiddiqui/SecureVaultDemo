//
//  FakeBiometricPreferenceStoring.swift
//  SecureVaultDemoTests
//
//  Created by hamza Ahmed on 2026-11-19.
//

import Foundation
@testable import SecureVaultDemo


final class FakeBiometricPreferenceStoring: BiometricPreferenceStoringProtocol {
    var isEnabled: Bool = false
}
