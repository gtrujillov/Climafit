//
//  HomeView.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedClothingCategory: String? = nil

    private var clothingItems: [Dictionary<String, String>.Element] {
        viewModel.clothingRecommendation?.clothCategory.map { $0 } ?? []
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea(edges: .all)

            VStack(spacing: 16) {
                //MARK: - Location section
                HStack {
                    VStack(alignment: .leading) {
                        Text("Ubicación")
                            .font(AppTheme.thinFont(size: .callout))
                        HStack{
                            Image(systemName: "location.fill")
                                .foregroundColor(AppTheme.primaryBrown)
                                .font(.system(size: 16))
                            Text(viewModel.weather?.name ?? "-")
                                .font(AppTheme.regularFont(size: .subheadline))
                        }
                    }
                    Spacer()
                }
                //MARK: - Weather section
                VStack(spacing: -4) {
                    HStack {
                        Text(viewModel.weather?.temperatureFormatted ?? "0.0º")
                            .font(AppTheme.boldFont(size: .largeTitle))
                        if let url = viewModel.weather?.iconURL {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                        }
                    }
                    Text(viewModel.weather?.description ?? viewModel.weatherDescription)
                        .font(AppTheme.regularFont(size: .small))
                }
                //MARK: - Recomendation section
                HStack {
                    VStack(alignment: .leading) {
                        Text("Recomendaciones")
                            .font(AppTheme.regularFont(size: .subheadline))
                        Text(viewModel.clothingRecommendation?.summary ?? "")
                            .font(AppTheme.thinFont(size: .callout))
                        
                        //MARK: - Categories
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(clothingItems, id: \.key) { item in
                                    ClothingCategoryItemView(
                                        iconName: item.value,
                                        onTap: {
                                            print("Seleccionaste \(item.key)")
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 24)
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

// MARK: - Mock para Preview

private struct MockGetWeatherUseCase: GetWeatherUseCase {
    func execute(lat: Double, lon: Double) async -> Weather {
        return Weather(
            temperature: 23.5,
            humidity: 65,
            windSpeed: 14.2,
            description: "Cielo parcialmente nublado",
            icon: "cloud.sun.fill",
            name: "Lisboa"
        )
    }
}

private struct MockGetLocationUseCase: GetLocationUseCase {
    func execute() async throws -> CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: 40.123432452, longitude: -3.3243534)
    }
}

private struct MockGetClothingRecommendationUseCase: GetClothingRecommendationUseCase {
    func execute(temperature: Double) -> ClothingRecommendation {
        return ClothingRecommendation(
            summary: "Ropa ligera, hace calor.",
            clothCategory: [
                "camiseta": "tshirt",
                "pantalón corto": "shorts",
                "gafas de sol": "sun.max.fill"
            ]
        )
    }
}

#Preview {
    let mockLocationUseCase = MockGetLocationUseCase()
    let mockUseCase = MockGetWeatherUseCase()
    let viewModel = HomeViewModel(getLocationUseCase: mockLocationUseCase, getWeatherUseCase: mockUseCase, getClothingRecomentadionUseCase: MockGetClothingRecommendationUseCase())
    HomeView(viewModel: viewModel)
}
