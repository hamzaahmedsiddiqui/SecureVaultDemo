import Foundation

struct FirebaseAuthenticationRepository: AuthenticationRepository {
    
    private enum Endpoint: String {
        case signIn = "signInWithPassword"
        case signUp
        case passwordReset = "sendOobCode"
    }
    
    let httpClient: HTTPClient

    func login(email: String, password: String) async throws -> AuthSession {
        try await authenticate(
            endpoint: .signIn,
            email: email,
            password: password
        )
    }

    func signUp(email: String, password: String) async throws -> AuthSession {
        try await authenticate(
            endpoint: .signUp,
            email: email,
            password: password
        )
    }

    func forgotPassword(email: String) async throws {
        let request =  try makeRequest(url: makeURL(for: .passwordReset), body: FirebaseSendPasswordResetRequest(email: email))

        do {
            let _: FirebaseSendPasswordResetResponse =
                try await httpClient.send(request)
        } catch NetworkError.serverError(_, let data) {
            // Avoid revealing whether an email is registered.
            guard firebaseErrorMessage(from: data) != "EMAIL_NOT_FOUND" else {
                return
            }

            throw ForgotPasswordError.serverError
        } catch is URLError {
            throw ForgotPasswordError.networkUnavailable
        } catch {
            throw ForgotPasswordError.unknown
        }
    }

    private func authenticate(
        endpoint: Endpoint,
        email: String,
        password: String
    ) async throws -> AuthSession {
        let url = try makeURL(for: endpoint)

        do {
            let request = try makeRequest(
                url: url,
                body: FirebaseAuthRequest(
                    email: email,
                    password: password,
                    returnSecureToken: true
                )
            )

            let response: FirebaseAuthResponse =
                try await httpClient.send(request)

            return AuthSession(
                accessToken: response.idToken,
                refreshToken: response.refreshToken,
                expiresAt: Date().addingTimeInterval(response.expiresIn)
            )
        } catch NetworkError.serverError(_, let data) {
            throw mapAuthenticationError(from: data)
        } catch is URLError {
            throw SignUpError.networkUnavailable
        } catch {
            throw SignUpError.unknown
        }
    }

    private func makeURL(for endpoint: Endpoint) throws -> URL {
        var components = URLComponents(
            string: "\(FirebaseConfig.baseURLAccounts):\(endpoint.rawValue)"
        )

        components?.queryItems = [
            URLQueryItem(name: "key", value: FirebaseConfig.apiKey)
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        return url
    }


    private func makeRequest<Body: Encodable>(
        url: URL,
        body: Body
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = try JSONEncoder().encode(body)

        return request
    }

    private func firebaseErrorMessage(from data: Data) -> String? {
        let response = try? JSONDecoder().decode(
            FirebaseErrorResponse.self,
            from: data
        )

        return response?.error.message
    }

    private func mapAuthenticationError(from data: Data) -> SignUpError {
        switch firebaseErrorMessage(from: data) {
        case "EMAIL_EXISTS":
            return .emailAlreadyInUse

        case let message? where message.hasPrefix("WEAK_PASSWORD"):
            return .weakPassword

        default:
            return .unknown
        }
    }
}
