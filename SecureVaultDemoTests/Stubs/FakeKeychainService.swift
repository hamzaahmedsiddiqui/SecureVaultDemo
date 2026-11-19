//
//  FakeKeychainService.swift
//  SecureVaultDemoTests
//
//  Created by hamza Ahmed on 2026-11-19.
//

import Foundation
@testable import SecureVaultDemo

final class FakeKeychainService: KeychainServiceProtocol{
    private var storage: [String: String] = [:]
    
    func save(_ value: String, for key: SecureVaultDemo.KeychainKey.RawValue) throws {
        storage[key] = value
    }
    
    func read(for key: SecureVaultDemo.KeychainKey.RawValue) throws -> String? {
        storage[key]
    }
    
    func delete(for key: SecureVaultDemo.KeychainKey.RawValue) throws {
        storage.removeValue(forKey: key)
    }  
}
