//
//  FireBaseSignInDTO.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-08.
//

import Foundation

struct FirebaseSignInResponseDTO: Decodable {
    let localId: String
    let email: String
    let displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
}

extension FirebaseSignInResponseDTO {
    func toDomain() throws -> AuthSession {
        guard let payload = JWT.decodeJWTPayload(idToken),
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
