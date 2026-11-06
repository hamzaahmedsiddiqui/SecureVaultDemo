//
//  ForgotPasswordUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-05.
//


struct ForgotPasswordUseCase {
    let repository: AuthenticationRepository

    func execute(email: String) async throws {
        try await repository.forgotPassword(email: email)
    }
}