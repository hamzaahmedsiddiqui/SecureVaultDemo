//
//  AuthenticationRepository.swift.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-01.
//

import Foundation

protocol AuthenticationRepository: Sendable {
    func login(email: String, password: String) async throws -> AuthSession
    func signUp(email: String, password: String) async throws -> AuthSession
}
