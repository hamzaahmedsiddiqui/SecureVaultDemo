
import SwiftUI

struct SignUpView: View {
    @Bindable var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(spacing: 16){
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
            SecureField("Password", text: $viewModel.confirmPassword)
                .textContentType(.password)
            if let errorMessage = viewModel.errorMessage{
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            Button("Sign Up"){
                Task{
                    await viewModel.signUp()
                }
            }
            .disabled(viewModel.isLoading)
        }.padding()
    }
}


#Preview {
    SignUpView(viewModel: AppCompositionRoot.makeSignUpViewModel {})
}
