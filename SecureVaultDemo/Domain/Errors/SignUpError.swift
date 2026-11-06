//
//  SignUpError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-04.
//

import Foundation

enum SignUpError: Error {
    case emailAlreadyInUse
    case weakPassword
    case networkUnavailable
    case serverError
    case unknown
}
