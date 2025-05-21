import Foundation
import Combine

protocol PexelsAPIProtocol {
    func fetchPhotos(query: String, perPage: Int) -> AnyPublisher<[PexelsPhoto], Error>
}

class PexelsAPI: PexelsAPIProtocol {
    private let apiKey: String
    private let baseURL = "https://api.pexels.com/v1/search"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchPhotos(query: String, perPage: Int = 20) -> AnyPublisher<[PexelsPhoto], Error> {
        guard let url = URL(string: "\(baseURL)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "ropa")&per_page=\(perPage)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PexelsResponse.self, decoder: JSONDecoder())
            .map { $0.photos }
            .eraseToAnyPublisher()
    }
    
    // Método para compatibilidad con la lógica de las vistas (callback style)
    func searchPhotos(query: String, completion: @escaping (Result<[PexelsPhoto], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "ropa")&per_page=10") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(PexelsResponse.self, from: data)
                completion(.success(decoded.photos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
} 
