import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn{
            DashboardView(
                viewModel: AppCompositionRoot.makeDashboardViewModel(
                    onLogout: {
                        isLoggedIn = false
                    })
            )}else {
                LoginView(
                    viewModel: AppCompositionRoot.makeLoginViewModel(
                        onLoginSuccess: {
                            isLoggedIn =  true
                        })
                )
            }
    }
}

#Preview {
    ContentView()
}

