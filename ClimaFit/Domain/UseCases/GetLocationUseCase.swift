//
//  GetLocationUseCase.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import CoreLocation

protocol GetLocationUseCase {
    func execute() async throws -> CLLocationCoordinate2D?
}

struct GetLocationUseCaseImpl: GetLocationUseCase {
    let repository: LocationRepository

    func execute() async throws -> CLLocationCoordinate2D? {
        do {
            return try await repository.getCurrentLocation()
        } catch {
            return nil
        }
    }
}
