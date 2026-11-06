//
//  AuthenticationRepository.swift
//  SecureVaultDemo
//
//  Created by hamza Ahmed on 2026-11-06.
//

import Foundation

struct FirebaseAuthenticationRepository: AuthenticationRepository{
    let httpClient: HTTPClient
    let QueryItemApiKey = [URLQueryItem(name: "key", value: FirebaseConfig.apiKey)]
    
    func login(email: String, password: String) async throws -> AuthSession {
        var components = URLComponents(string: "\(FirebaseConfig.baseURLAccounts):signInWithPassword")
        components?.queryItems = QueryItemApiKey
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = requestBuilder(url: url, httpMettod: .post)


    }
    
    func signUp(email: String, password: String) async throws -> AuthSession {
        
        var components = URLComponents(string: "\(FirebaseConfig.baseURLAccounts)/accounts:signUp")
        components?.queryItems = QueryItemApiKey
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = requestBuilder(url: url, httpMettod: .post)
        
        do{
            let body = FirebaseSignUpRequest(email: email, password: password, returnSecureToken: true)
            request.httpBody = try JSONEncoder().encode(body)
            
            let response: FirebaseAuthResponse = try await httpClient.send(request)
            
            return AuthSession(
                accessToken: response.idToken,
                refreshToken: response.refreshToken,
                expiresAt: Date().addingTimeInterval(response.expiresIn)
            )
        } catch NetworkError.serverError(_, let data){
            throw mapSignUpError(from: data)
        } catch is URLError {
            throw SignUpError.networkUnavailable
        } catch {
            throw SignUpError.unknown
        }
    }
    
    private func mapSignUpError(from data: Data) -> SignUpError {
            guard let errorResponse = try? JSONDecoder().decode(FirebaseErrorResponse.self, from: data) else {
                return .unknown
            }

            switch errorResponse.error.message {
            case "EMAIL_EXISTS":
                return .emailAlreadyInUse
            case let message where message.hasPrefix("WEAK_PASSWORD"):
                return .weakPassword
            default:
                return .unknown
            }
        }
    private func requestBuilder(url: URL, httpMettod: HTTPMethod) -> URLRequest{
        var request =  URLRequest(url: url)
        request.httpMethod = httpMettod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func forgotPassword(email: String) async throws {
        <#code#>
    }
    
}
