//
//  LoginUseCase.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-01.
//

import Foundation

struct LoginUseCase {
    let repository: AuthenticationRepository // -> repo protocol
    
    func execute(email: String, password: String) async throws -> AuthSession {
        try await repository.login(email: email, password: password)
    }
}
