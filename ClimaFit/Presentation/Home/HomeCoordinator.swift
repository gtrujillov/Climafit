//
//  HomeCoordinator.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import SwiftUI

protocol HomeCoordinator {
    @MainActor
    func start() -> AnyView
}

@MainActor
struct HomeCoordinatorImpl: HomeCoordinator {
    func start() -> AnyView {
        // API Client para el clima
        let apiClient = WeatherAPIClient()
        
        // Repositorio para clima
        let weatherRepository = WeatherRepositoryImpl(apiClient: apiClient)
        
        // Caso de uso para obtener clima
        let getWeatherUseCase = GetWeatherUseCaseImpl(repository: weatherRepository)
        
        // Repositorio para ubicación
        let locationRepository = LocationRepositoryImpl()
        
        // Caso de uso para obtener ubicación
        let getLocationUseCase = GetLocationUseCaseImpl(repository: locationRepository)
        
        // ViewModel con ambos casos de uso
        let viewModel = HomeViewModel(
            getLocationUseCase: getLocationUseCase,
            getWeatherUseCase: getWeatherUseCase
        )
        
        return AnyView(HomeView(viewModel: viewModel))
    }
}
