//
//  GetClothingRecommendationUseCase.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import Foundation

protocol GetClothingRecommendationUseCase {
    func execute(temperature: Double) -> ClothingRecommendation
}

struct GetClothingRecommendationUseCaseImpl: GetClothingRecommendationUseCase {
    func execute(temperature: Double) -> ClothingRecommendation {
        ClothingRecommendation.forTemperature(temperature)
    }
}
