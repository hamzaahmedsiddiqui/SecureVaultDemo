//
//  SecureVaultDemoApp.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-09-12.
//
import SwiftUI

@main
struct SecureVaultDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: AppCompositionRoot.makeAppStateViewMode())
        }
    }
}
