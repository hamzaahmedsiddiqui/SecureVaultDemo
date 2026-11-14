//
//  KeychainServiceProtocol.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-06.
//

import Foundation
import Security

final class KeychainService: KeychainServiceProtocol{
    
    func save(_ value: String, for key: KeychainKey.RawValue) throws {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: data,
                                    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Remove any existing item first, so save() also works as an update
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave(status)
        }
    }
    
    func read(for key: KeychainKey.RawValue) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainError.unableToRead(status)
            }
            return String(data:data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unableToRead(status)
        }
    }
    
    func delete(for key: KeychainKey.RawValue) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete(status)
        }
    }
}
