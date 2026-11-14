import Foundation

enum ForgotPasswordError: Error {
    case networkUnavailable, serverError, unknown
}
