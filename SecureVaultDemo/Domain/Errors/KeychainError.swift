//
//  KeychainError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//
import Foundation
import Security

enum KeychainError: Error {
    case unableToSave(OSStatus)
    case unableToRead(OSStatus)
    case unableToDelete(OSStatus)
}
