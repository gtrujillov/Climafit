import Foundation
import Combine
import CoreLocation

protocol WeatherAPIProtocol {
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error>
}

class WeatherAPI: WeatherAPIProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    init(networkService: NetworkServiceProtocol = NetworkService(), apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error> {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&lang=es&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return networkService.fetch(url)
            .map { (response: WeatherResponse) -> Weather in
                Weather(
                    temperature: response.main.temp,
                    humidity: response.main.humidity,
                    windSpeed: response.wind.speed,
                    description: response.weather.first?.description ?? "",
                    icon: response.weather.first?.icon ?? ""
                )
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - API Response Models
private struct WeatherResponse: Codable {
    let weather: [WeatherDetail]
    let main: MainWeather
    let wind: Wind
    
    struct WeatherDetail: Codable {
        let description: String
        let icon: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
} 