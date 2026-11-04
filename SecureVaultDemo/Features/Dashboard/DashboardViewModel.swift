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
    let logoutUseCase: LogoutUseCase
    
    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }

    func logout() async {
        await logoutUseCase.execute()
    }
}
