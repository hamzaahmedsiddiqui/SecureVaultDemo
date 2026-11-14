//
//  KeychainServiceProtocol.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//

protocol KeychainServiceProtocol {
    func save(_ value: String, for key: KeychainKey.RawValue) throws
    func read(for key: KeychainKey.RawValue) throws -> String?
    func delete(for key: KeychainKey.RawValue) throws
}
