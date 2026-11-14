import Foundation
import LocalAuthentication

enum KeychainKey: String{
    case accessToken
    case refreshToken
    case expiresAt
}

actor SessionManager {
    private var session: AuthSession?
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func hasSavedSession() async throws -> Bool {
         try await keychainService.read(for: KeychainKey.accessToken.rawValue) != nil
     }
    
    func restoreSession() async throws -> Bool {
        guard let accessToken = try await getCurrentAccessToken(),
              let refreshToken = try await getCurrentRefereshToken(),
              let expiresAt = try await getCurrentExpireDate()
        else {
            return false
        }
        self.session = AuthSession(accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiresAt)
        return true
    }
    
    func start(with session: AuthSession) async throws {
        

        self.session = session
        try await keychainService.save(session.accessToken, for: KeychainKey.accessToken.rawValue)
        try await keychainService.save(session.refreshToken, for:  KeychainKey.refreshToken.rawValue)
       
        let expiresAt = dateToString(date: session.expiresAt)
        try await keychainService.save(expiresAt, for:KeychainKey.expiresAt.rawValue)
    }
    
    func getCurrentAccessToken() async throws -> String? {
        try await keychainService.read(for: KeychainKey.accessToken.rawValue)
    }
    
    func getCurrentRefereshToken() async throws -> String? {
        try await keychainService.read(for: KeychainKey.refreshToken.rawValue)
    }
    
    func getCurrentExpireDate() async throws -> Date? {
        guard let expString = try await keychainService.read(for: KeychainKey.expiresAt.rawValue) else {
            return nil   // nothing saved — perfectly normal, not an error
        }
        guard let exp = TimeInterval(expString) else {
            throw KeychainError.unableToRead(errSecItemNotFound)   // present but unparseable — genuinely broken
        }
        return Date(timeIntervalSince1970: exp)
    }
    
    func clear() async throws {
        try await keychainService.delete(for: KeychainKey.accessToken.rawValue)
        try await keychainService.delete(for: KeychainKey.refreshToken.rawValue)
        try await keychainService.delete(for: KeychainKey.expiresAt.rawValue)
        self.session = nil
    }
    
    private func dateToString(date: Date) -> String {
        String(date.timeIntervalSince1970)
    }
    
}
