import Foundation

struct FirebaseAuthRequest: Encodable {
    let email: String
    let password: String
    let returnSecureToken: Bool
}

struct FirebaseAuthResponse: Decodable {
    let idToken: String
    let refreshToken: String
    let expiresIn: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case idToken, refreshToken, expiresIn
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idToken = try container.decode(String.self, forKey: .idToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        
        guard let seconds = TimeInterval(try container.decode(String.self, forKey: .expiresIn)) else {
            throw DecodingError.dataCorruptedError(forKey: .expiresIn, in: container, debugDescription: "expiresIn was not a valid numeric string")
        }
        expiresIn = seconds
    }
}

struct FirebaseErrorResponse: Decodable {
    let error: ErrorDetail
    
    struct ErrorDetail: Decodable {
        let code : Int
        let message: String
    }
}

struct FirebaseSendPasswordResetRequest: Encodable {
    let requestType: String = "PASSWORD_RESET"
    let email: String
}

struct FirebaseSendPasswordResetResponse: Decodable {
    let email: String
}
