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
}

struct URLSessionHTTPClient: HTTPClient {
    func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}