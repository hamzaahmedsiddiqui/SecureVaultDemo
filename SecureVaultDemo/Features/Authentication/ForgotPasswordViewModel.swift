import Foundation

@MainActor
@Observable
final class ForgotPasswordViewModel {
    private let forgotPasswordUseCase: ForgotPasswordUseCase

    var email = ""
    var isLoading = false
    var errorMessage: String?
    var didSendResetEmail = false

    init(forgotPasswordUseCase: ForgotPasswordUseCase) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
    }

    func submit() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        do {
            try await forgotPasswordUseCase.execute(email: email)
            didSendResetEmail = true
        } catch let error as ForgotPasswordError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = "Something went wrong. Please try again"
        }
    }

    private func message(for error: ForgotPasswordError) -> String {
        switch error {
        case .networkUnavailable: return "No internet connection"
        case .serverError: return "Server error. Please try again later."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
