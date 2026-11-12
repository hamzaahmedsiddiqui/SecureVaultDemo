import SwiftUI

enum AuthScreen {
    case login
    case signUp
    case forgotPassword
}

enum AuthState {
    case checking
    case loggedIn
    case loggedOut
}

struct ContentView: View {
    @State private var authState: AuthState = .checking
    @State private var authScreen: AuthScreen = .login

    var body: some View {
        Group {
            switch authState {
            case .checking:
                ProgressView()
            case .loggedIn:
                DashboardView(
                    viewModel: AppCompositionRoot.makeDashboardViewModel(
                        onLogout: { authState = .loggedOut }
                    )
                )
            case .loggedOut:
                authContent
            }
        }
        .task {
            let restored = (try? await AppCompositionRoot.sessionManager.restoreSession()) ?? false
            authState = restored ? .loggedIn : .loggedOut
        }
    }

    @ViewBuilder
    private var authContent: some View {
        switch authScreen {
        case .login:
            LoginView(
                viewModel: AppCompositionRoot.makeLoginViewModel(
                    onLoginSuccess: { authState = .loggedIn }
                ),
                onSignUpTapped: { authScreen = .signUp },
                onForgetPasswordTapped: { authScreen = .forgotPassword }
            )
        case .signUp:
            SignUpView(
                viewModel: AppCompositionRoot.makeSignUpViewModel { authState = .loggedIn },
                onLoginTapped: { authScreen = .login }
            )
        case .forgotPassword:
            ForgotPasswordView(
                viewModel: AppCompositionRoot.makeForgotPasswordViewModel(),
                onBackToLogin: { authScreen = .login }
            )
        }
    }
}

#Preview {
    ContentView()
}

// Creditials
// test@securevault.com
// password123
