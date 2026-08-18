import Foundation

// MARK: - Endpoint

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

extension Endpoint {
    var baseURL: URL {
        // Replace with actual NestJS Core API URL
        URL(string: "https://api.empowerhumanity.ai/v1")!
    }

    var headers: [String: String] {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }

    var queryItems: [URLQueryItem]? { nil }
    var body: Encodable? { nil }

    func urlRequest(authToken: String? = nil) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var allHeaders = headers
        if let token = authToken {
            allHeaders["Authorization"] = "Bearer \(token)"
        }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
}

// MARK: - Errors

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int, Data?)
    case decodingError(Error)
    case networkError(Error)
    case unauthorized
    case notFound
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        case .httpError(let code, _): return "HTTP error \(code)"
        case .decodingError(let err): return "Failed to decode response: \(err.localizedDescription)"
        case .networkError(let err): return "Network error: \(err.localizedDescription)"
        case .unauthorized: return "Authentication required"
        case .notFound: return "Resource not found"
        case .serverError(let msg): return "Server error: \(msg)"
        }
    }
}

// MARK: - APIClient

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private var authToken: String?

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)

        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601

        self.encoder = JSONEncoder()
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder.dateEncodingStrategy = .iso8601
    }

    func setAuthToken(_ token: String?) {
        self.authToken = token
    }

    func request<T: Decodable>(_ endpoint: some Endpoint, responseType: T.Type) async throws -> T {
        let request = try endpoint.urlRequest(authToken: authToken)
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            case 401:
                throw APIError.unauthorized
            case 404:
                throw APIError.notFound
            case 400..<500:
                throw APIError.httpError(httpResponse.statusCode, data)
            case 500...:
                throw APIError.serverError("Internal server error")
            default:
                throw APIError.httpError(httpResponse.statusCode, data)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    func requestVoid(_ endpoint: some Endpoint) async throws {
        let request = try endpoint.urlRequest(authToken: authToken)
        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode, nil)
        }
    }
}
