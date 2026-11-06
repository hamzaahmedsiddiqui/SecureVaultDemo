//
//  NetworkError.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-06.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int, data: Data)
    case decodingFailed
    case invalidURL
}
