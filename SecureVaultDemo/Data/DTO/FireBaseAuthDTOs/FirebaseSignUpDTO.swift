
import Foundation

struct FirebaseSignUpResponse: Decodable {
        let idToken: String
        let email: String
        let refreshToken: String
        let expiresIn: String  
        let localId: String
}

enum AuthMappingError: Error {
    case invalidExpiration(String)
}

extension FirebaseSignUpResponse {
    func toDomain(now: Date = Date()) throws -> AuthSession {
        guard let payload = FirebaseSignInResponseDTO.decodeJWTPayload(idToken),
              let exp = payload["exp"] as? TimeInterval else {
            throw AuthMappingError.invalidExpiration("missing exp claim")
        }
        let expiresAt = Date(timeIntervalSince1970: exp)

        return AuthSession(
            accessToken: idToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
    }
}

struct FirebaseAuthRequest: Encodable {
    let email: String
    let password: String
    let returnSecureToken: Bool
}
