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
    
    private let getLocationUseCase: GetLocationUseCase
    private let getWeatherUseCase: GetWeatherUseCase

    init(getLocationUseCase: GetLocationUseCase, getWeatherUseCase: GetWeatherUseCase) {
        self.getLocationUseCase = getLocationUseCase
        self.getWeatherUseCase = getWeatherUseCase
    }

    func onAppear() {
        guard (weather != nil) else {
            return
        }
        Task {
            do {
                if let location = try await getLocationUseCase.execute() {
                    self.weather = await getWeatherUseCase.execute(lat: location.latitude, lon: location.longitude)
                } else {
                    self.weatherDescription = "No se pudo obtener la ubicación"
                }
            } catch {
                self.weatherDescription = "Error obteniendo ubicación"
            }
        }
    }
}
