//
//  SearchCityUseCase.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 21/5/25.
//

import Foundation
import CoreLocation

protocol SearchCityUseCase {
    func execute(city: String) async throws -> CLLocation
}
