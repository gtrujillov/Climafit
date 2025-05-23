//
//  WeatherAPIClient.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation

struct WeatherDTO: Decodable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let name: String

    struct WeatherInfo: Decodable {
        let description: String
        let icon: String
    }

    struct MainInfo: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct WindInfo: Decodable {
        let speed: Double
    }
}

final class WeatherAPIClient {
    func getWeather(lat: Double, lon: Double) async throws -> WeatherDTO {
        let apiKey = Config.openWeatherAPIKey
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=es&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(WeatherDTO.self, from: data)
    }
}
