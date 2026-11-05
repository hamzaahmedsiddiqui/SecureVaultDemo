import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false
    @State var signUpTapped: Bool = false
    
    var body: some View {
        if isLoggedIn{
            DashboardView(
                viewModel: AppCompositionRoot.makeDashboardViewModel(
                    onLogout: {
                        isLoggedIn = false
                    })
            )} else if signUpTapped{
                SignUpView(viewModel: AppCompositionRoot.makeSignUpViewModel {
                    isLoggedIn = true
                }, onLoginTapped: { signUpTapped = false })
            } else {
                LoginView(
                    viewModel: AppCompositionRoot.makeLoginViewModel(
                        onLoginSuccess: {
                            isLoggedIn =  true
                        }), onSignUpTapped: { signUpTapped = true }
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
