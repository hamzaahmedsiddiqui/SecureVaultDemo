import SwiftUI

enum AuthScreen {
    case login
    case signUp
    case forgotPassword
}


struct ContentView: View {
    @State var isLoggedIn: Bool = false
    @State private var authScreen: AuthScreen = .login
    
    var body: some View {
        if isLoggedIn {
            DashboardView(
                viewModel: AppCompositionRoot
                    .makeDashboardViewModel(
                        onLogout: {
                            isLoggedIn = false
                        })
            )
        } else {
            switch authScreen {
            case .login:
                LoginView(
                    viewModel: AppCompositionRoot
                        .makeLoginViewModel(
                            onLoginSuccess: {
                                isLoggedIn =  true
                            }),
                    onSignUpTapped: {
                        //signUpTapped = true
                        authScreen = .signUp
                    },
                    onForgetPasswordTapped: {
                        authScreen = .forgotPassword
                    }
                )
            case .signUp:
                SignUpView(
                    viewModel: AppCompositionRoot.makeSignUpViewModel {
                        isLoggedIn = true
                    },
                    onLoginTapped: {
                        authScreen = .login
                    })
            case .forgotPassword:
                ForgotPasswordView(viewModel: AppCompositionRoot.makeForgotPasswordViewModel(), onBackToLogin: {
                    authScreen = .login
                })
            }
        }
    }
}

#Preview {
    ContentView()
}

// Creditials
// test@securevault.com
// password123
