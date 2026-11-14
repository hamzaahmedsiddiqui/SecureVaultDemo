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
    @State private var authScreen: AuthScreen = .login
    let viewModel: AppStateViewModel
    
    var body: some View {
        Group {
            switch viewModel.authState {
            case .checking:
                ProgressView()
            case .loggedIn:
                DashboardView(
                    viewModel: AppCompositionRoot.makeDashboardViewModel(
                        onLogout: { viewModel.authState = .loggedOut }
                    )
                )
            case .loggedOut:
                authContent
            }
        }
        .task {
            await viewModel.checkSession()
        }
    }

    @ViewBuilder
    private var authContent: some View {
        switch authScreen {
        case .login:
            LoginView(
                viewModel: AppCompositionRoot.makeLoginViewModel(
                    onLoginSuccess: { viewModel.authState = .loggedIn }
                ),
                onSignUpTapped: { authScreen = .signUp },
                onForgetPasswordTapped: { authScreen = .forgotPassword }
            )
        case .signUp:
            SignUpView(
                viewModel: AppCompositionRoot.makeSignUpViewModel { viewModel.authState = .loggedIn },
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

//#Preview {
//    ContentView()
//}

// Creditials
// test@securevault.com
// password123
