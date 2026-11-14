//
//  DashboardView.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//

import SwiftUI

struct DashboardView: View {
    let viewModel: DashboardViewModel

    @State private var showLogoutConfirmation = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.green)

                Text("You're securely logged in")
                    .font(.title2.bold())

                Text("Your session is protected by biometric authentication and stored securely in the Keychain.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            Button(role: .destructive) {
                showLogoutConfirmation = true
            } label: {
                Text("Log Out")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Log Out", role: .destructive) {
                Task { await viewModel.logout() }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    DashboardView(viewModel: AppCompositionRoot.makeDashboardViewModel(onLogout: {}))
}
