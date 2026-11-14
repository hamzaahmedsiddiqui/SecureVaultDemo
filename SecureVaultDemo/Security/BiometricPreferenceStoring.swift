//
//  BiometricPreferenceStoring.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//
import Foundation

struct BiometricPreferenceStoring: BiometricPreferenceStoringProtocol {
    private let key = "biometricLoginEnabled"
    private let userDefault: UserDefaults
    
    init(userDefault: UserDefaults = .standard) {
        self.userDefault = userDefault
    }
    
    var isEnabled: Bool {
        get { userDefault.bool(forKey: key) }
        set { userDefault.set(newValue, forKey: key) }
    }
}
