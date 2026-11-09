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


extension FirebaseSignInResponseDTO {
    static func decodeJWTPayload(_ token: String) -> [String: Any]? {
        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return nil }   // not 3 parts = not a real JWT
        
        var base64 = String(segments[1])                // the middle segment only
        base64 = base64
            .replacingOccurrences(of: "-", with: "+")    // JWTs use URL-safe base64,
            .replacingOccurrences(of: "_", with: "/")    // Foundation wants standard base64
        
        while base64.count % 4 != 0 {                    // base64 needs length divisible by 4
            base64 += "="                                // pad it out if it's short
        }
        
        guard let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
