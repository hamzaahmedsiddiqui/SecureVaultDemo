//
//  SignUpUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-04.
//

import Foundation
protocol SignUpUseCaseProtocol{
    func execute(email: String, password: String) async throws -> AuthSession
}

struct SignUpUseCase: SignUpUseCaseProtocol {
    private let repository: AuthenticationRepository
    private let sessionManager: SessionManager
    
    init(repository: AuthenticationRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func execute(email: String, password: String) async throws -> AuthSession{
        let session = try await repository.signUp(email: email, password: password)
        try await sessionManager.start(with: session)
        return session
    }
}
