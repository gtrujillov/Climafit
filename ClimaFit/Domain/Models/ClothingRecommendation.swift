//
//  ClothingRecommendation.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import Foundation

struct ClothingRecommendation: Identifiable {
    var id: String { summary }
    let summary: String
    let clothCategory: [String : String]

    static func forTemperature(_ temperature: Double) -> ClothingRecommendation {
        switch temperature {
        case ..<5:
            return ClothingRecommendation(
                summary: "Usa abrigo, bufanda y guantes",
                clothCategory: [
                    "abrigo": "thermometer.snowflake",
                    "bufanda": "scarf",
                    "guantes": "hand.raised.fill"
                ]
            )
        case 5..<15:
            return ClothingRecommendation(
                summary: "Lleva chaqueta y algo de abrigo",
                clothCategory: [
                    "chaqueta": "cloud.drizzle.fill",
                    "jersey": "sweater"
                ]
            )
        case 15..<22:
            return ClothingRecommendation(
                summary: "Ropa ligera con una chaqueta opcional",
                clothCategory: [
                    "camiseta": "tshirt",
                    "chaqueta ligera": "light.jacket"
                ]
            )
        case 22..<30:
            return ClothingRecommendation(
                summary: "Ropa fresca y cómoda",
                clothCategory: [
                    "camiseta": "tshirt",
                    "pantalón corto": "shorts"
                ]
            )
        default:
            return ClothingRecommendation(
                summary: "Ropa muy ligera, protégete del sol",
                clothCategory: [
                    "tirantes": "tank.top",
                    "gafas de sol": "sun.max.fill",
                    "sombrero": "hat"
                ]
            )
        }
    }
}
