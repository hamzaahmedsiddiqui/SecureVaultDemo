//
//  DashboardViewModel.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//
import Foundation
import os

@MainActor
@Observable
final class DashboardViewModel {
    private let logoutUseCase: LogoutUseCaseProtocol
    private let onLogout: () -> Void
    var errorMessage: String?
    private let logger = Logger(OSLog(subsystem: "com.securevault.app", category: "dashboardViewModel"))

    init(logoutUseCase: LogoutUseCaseProtocol, onLogout: @escaping() -> Void) {
        self.logoutUseCase = logoutUseCase
        self.onLogout = onLogout
    }
    
    func logout() async {
        do {
            try await logoutUseCase.execute()
        } catch {
            logger.error("Logout failed: \(error.localizedDescription, privacy: .public)")
            errorMessage = "Logout couldn't fully complete, but you've been signed out."
        }
        onLogout()
    }
}
