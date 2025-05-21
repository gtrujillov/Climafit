import Foundation
import Combine

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta del servidor inválida"
        case .decodingError:
            return "Error al procesar los datos"
        case .serverError(let message):
            return message
        case .noData:
            return "No se recibieron datos de la red"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    switch httpResponse.statusCode {
                    case 401:
                        throw NetworkError.serverError("API Key inválida")
                    case 404:
                        throw NetworkError.serverError("Recurso no encontrado")
                    case 429:
                        throw NetworkError.serverError("Demasiadas peticiones")
                    default:
                        throw NetworkError.serverError("Error del servidor (\(httpResponse.statusCode))")
                    }
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return NetworkError.serverError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
} 