//
//  ForgotPasswordUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-05.
//

protocol ForgotPasswordUseCaseProtocol{
    func execute(email: String) async throws
}

struct ForgotPasswordUseCase: ForgotPasswordUseCaseProtocol {
    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository) {
        self.repository = repository
    }

    func execute(email: String) async throws {
        try await repository.forgotPassword(email: email)
    }
}
