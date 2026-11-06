//
//  SessionManager.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//

import Foundation

actor SessionManager {
    private var session: AuthSession?
    
    func start(with session: AuthSession) {
        self.session = session
    }
    
    func currentAccessToken() -> String? {
        session?.accessToken
    }
    
    func clear() {
        session = nil
    }
}
