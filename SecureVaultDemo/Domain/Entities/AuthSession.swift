//
//  AuthSession.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-09-19.
//

import Foundation

struct AuthSession: Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}
