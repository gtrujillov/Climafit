//
//  HomeViewModel.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import CoreLocation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var weatherDescription: String = ""
    @Published var clothingRecommendation: ClothingRecommendation?
    
    private let getLocationUseCase: GetLocationUseCase
    private let getWeatherUseCase: GetWeatherUseCase
    private let getClothingRecomentadionUseCase: GetClothingRecommendationUseCase

    init(
        getLocationUseCase: GetLocationUseCase,
        getWeatherUseCase: GetWeatherUseCase,
        getClothingRecomentadionUseCase: GetClothingRecommendationUseCase
    ) {
        self.getLocationUseCase = getLocationUseCase
        self.getWeatherUseCase = getWeatherUseCase
        self.getClothingRecomentadionUseCase = getClothingRecomentadionUseCase
    }

    func onAppear() {
        guard weather == nil else {
            return
        }

        Task {
            do {
                if let location = try await getLocationUseCase.execute() {
                    let weather = await getWeatherUseCase.execute(
                        lat: location.latitude,
                        lon: location.longitude
                    )
                    self.weather = weather
                    self.clothingRecommendation = getClothingRecomentadionUseCase.execute(temperature: weather.temperature)
                    self.weatherDescription = "\(weather.description) | \(weather.temperatureFormatted)"
                } else {
                    self.weatherDescription = "No se pudo obtener la ubicación"
                }
            } catch {
                self.weatherDescription = "Error obteniendo ubicación"
            }
        }
    }
}
