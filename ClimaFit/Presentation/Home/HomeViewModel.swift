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
    @Published var weatherDescription: String = "Cargando..."
    @Published var temperature: String = "0.0"
    @Published var place: String = "-"
    @Published var iconUrl: URL? = nil
    
    private let getLocationUseCase: GetLocationUseCase
    private let getWeatherUseCase: GetWeatherUseCase

    init(getLocationUseCase: GetLocationUseCase, getWeatherUseCase: GetWeatherUseCase) {
        self.getLocationUseCase = getLocationUseCase
        self.getWeatherUseCase = getWeatherUseCase
    }

    func onAppear() {
        Task {
            do {
                if let location = try await getLocationUseCase.execute() {
                    let weather = await getWeatherUseCase.execute(lat: location.latitude, lon: location.longitude)
                    self.weatherDescription = weather.description
                    self.temperature = weather.temperatureFormatted
                    self.place = weather.name
                    self.iconUrl = weather.iconURL
                } else {
                    self.weatherDescription = "No se pudo obtener la ubicación"
                }
            } catch {
                self.weatherDescription = "Error obteniendo ubicación"
            }
        }
    }
}
