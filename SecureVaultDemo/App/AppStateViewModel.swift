//
//  AppStateViewModel.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-13.
//

import Foundation
import os

@MainActor
@Observable

final class AppStateViewModel {
    var authState: AuthState = .checking
    private let restoreSessionUseCase: RestoreSessionUseCaseProtocol
    private let logger = Logger(OSLog(subsystem: "com.secureault.app", category: "AppState"))
    
    init(authState: AuthState, restoreSessionUseCase: RestoreSessionUseCaseProtocol) {
        self.authState = authState
        self.restoreSessionUseCase = restoreSessionUseCase
    }
    
    func checkSession() async {
        do {
            let restored =  try await restoreSessionUseCase.execute()
            authState = restored ? .loggedIn : .loggedOut
        } catch {
            logger.error("Failed tor restore session: \(error.localizedDescription, privacy: .public)")
            authState = .loggedOut
        }
    }
}
