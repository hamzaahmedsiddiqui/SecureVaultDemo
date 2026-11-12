//
//  LogoutUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//


struct LogoutUseCase {
    let sessionManager: SessionManager

    func execute() async throws{
        try await sessionManager.clear()
    }
}
