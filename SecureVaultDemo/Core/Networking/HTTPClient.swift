//
//  HTTPClient.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-06.
//

import Foundation

protocol HTTPClient: Sendable {
    func send<Response: Decodable>(_ request: URLRequest) async throws -> Response
}

