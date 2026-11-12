//
//  LoginUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-01.
//

struct LoginUseCase {
    let repository: AuthenticationRepository // -> repo protocol
    let sessionManager: SessionManager
    
    func execute(email: String, password: String) async throws -> AuthSession {
        let session = try await repository.login(email: email, password: password)
        try await sessionManager.start(with: session)
        return session
    }
}
