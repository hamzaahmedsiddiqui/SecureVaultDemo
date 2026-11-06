enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int, data: Data)
    case decodingFailed
}
