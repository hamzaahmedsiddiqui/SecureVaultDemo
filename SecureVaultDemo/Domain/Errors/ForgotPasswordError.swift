//
//  ForgetPasswordError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-05.
//

import Foundation

enum ForgotPasswordError: Error {
    case networkUnavailable
    case serverError
    case unknown
}
