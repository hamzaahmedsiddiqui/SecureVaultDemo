//
//  SignUpUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-04.
//

import Foundation

struct SignUpUseCase {
    let repository: AuthenticationRepository
    let sessionManager: SessionManager
    
    
    func execute(email: String, password: String) async throws -> AuthSession{
        let session = try await repository.signUp(email: email, password: password)
        await sessionManager.start(with: session)
        return session
    }
}
