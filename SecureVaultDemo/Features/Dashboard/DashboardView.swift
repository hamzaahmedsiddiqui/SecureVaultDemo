//
//  DashboardView.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-03.
//

import SwiftUI

struct DashboardView: View {
    let viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("You're logged in")
                .font(.title2)

            Button("Log Out") {
                Task {
                    await viewModel.logout()
                }
            }
        }
    }
}


#Preview {
    DashboardView(viewModel: AppCompositionRoot.makeDashboardViewModel())
}
