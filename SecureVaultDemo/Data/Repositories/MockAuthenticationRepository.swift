//
//  MockAuthenticationRepository.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-01.
//

import Foundation

struct MockAuthenticationRepository: AuthenticationRepository {
    func forgotPassword(email: String) async throws {
        try await Task.sleep(for: .seconds(1))
        // Intentionally no check on whether this email is a real account.
        // Success here must look identical whether the email exists or not —
        // that's the whole point of avoiding account enumeration.
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        try await Task.sleep(for: .seconds(1))
        
        guard email == "test@securevault.com", password == "password123" else {
            throw LoginError.invalidCredentials
        }
        
        return AuthSession(accessToken: "mock-access-token", refreshToken: "mock-refresh-token", expiresAt: Date().addingTimeInterval(900))
    }
    
    func signUp(email: String, password: String) async throws -> AuthSession{
        try await Task.sleep(for: .seconds(1))
        
        guard email != "test@securevault.com" else {
            throw SignUpError.emailAlreadyInUse
        }
        
        guard password.count >= 8 else {
            throw SignUpError.weakPassword
        }
        
        return AuthSession(accessToken: "mock-access-token", refreshToken: "mock-refresh-token", expiresAt: Date().addingTimeInterval(900))
    }
}
