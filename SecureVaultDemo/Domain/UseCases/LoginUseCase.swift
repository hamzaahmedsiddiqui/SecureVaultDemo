//
//  LoginUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-01.
//
protocol LoginUseCaseProtocol{
    func execute(email: String, password: String) async throws -> AuthSession
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthenticationRepository // -> repo protocol
    private let sessionManager: SessionManager
    
    init(repository: AuthenticationRepository, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }
    
    func execute(email: String, password: String) async throws -> AuthSession {
        let session = try await repository.login(email: email, password: password)
        try await sessionManager.start(with: session)
        return session
    }
}
