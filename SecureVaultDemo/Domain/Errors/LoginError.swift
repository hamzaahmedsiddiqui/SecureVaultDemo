//
//  LoginError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-10-31.
//

import Foundation

enum LoginError: Error, Sendable {
    case invalidCredentials
    case networkUnabailable
    case serverError
    case unknown
}
