//
//  FirebaseSendPasswordResetRequest.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-08.
//


struct FirebaseSendPasswordResetRequest: Encodable {
    let requestType: String = "PASSWORD_RESET"
    let email: String
}
struct FirebaseSendPasswordResetResponse: Decodable {
    let email: String
}
