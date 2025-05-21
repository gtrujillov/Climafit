//
//  SearchBarViewModel.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 21/5/25.
//

import Foundation
import CoreLocation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var locationResult: CLLocation?

    private let searchCityUseCase: SearchCityUseCase

    init(searchCityUseCase: SearchCityUseCase) {
        self.searchCityUseCase = searchCityUseCase
    }

    func performSearch() async {
        guard !searchText.isEmpty else { return }
        do {
            locationResult = try await searchCityUseCase.execute(city: searchText)
        } catch {
            print("Error: \(error)")
        }
    }
}
