//
//  LocationRepository.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import CoreLocation

protocol LocationRepository {
    func getCurrentLocation() async throws -> CLLocationCoordinate2D
}

