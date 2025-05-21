//
//  DefaultSearchCityUseCase.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 21/5/25.
//

import Foundation
import CoreLocation

final class DefaultSearchCityUseCase: SearchCityUseCase {
    private let geocoder: CLGeocoder = .init()

    func execute(city: String) async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(city) { placemarks, error in
                if let location = placemarks?.first?.location {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "SearchCityError", code: -1))
                }
            }
        }
    }
}
