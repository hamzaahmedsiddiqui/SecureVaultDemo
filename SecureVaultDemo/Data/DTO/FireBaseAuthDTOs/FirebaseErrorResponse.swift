//
//  FirebaseErrorResponse.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-08.
//


struct FirebaseErrorResponse: Decodable {
    let error: ErrorDetail
    
    struct ErrorDetail: Decodable {
        let code : Int
        let message: String
    }
}