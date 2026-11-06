protocol HTTPClient: Sendable {
    func send<Response: Decodable>(_ request: URLRequest) async throws -> Response
}