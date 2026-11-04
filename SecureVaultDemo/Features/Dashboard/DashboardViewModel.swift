//
//  DashboardViewModel.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//
import Foundation

@MainActor
@Observable
final class DashboardViewModel {
    private let logoutUseCase: LogoutUseCase
    private let onLogout: () -> Void
    
    init(logoutUseCase: LogoutUseCase, onLogout: @escaping() -> Void) {
        self.logoutUseCase = logoutUseCase
        self.onLogout = onLogout
    }

    func logout() async {
        await logoutUseCase.execute()
        onLogout()
    }
}
