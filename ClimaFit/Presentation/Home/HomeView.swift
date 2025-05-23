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

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea(edges: .all)

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Ubicación")
                            .font(AppTheme.thinFont(size: .callout))
                        HStack{
                            Image(systemName: "location.fill")
                                .foregroundColor(AppTheme.primaryBrown)
                                .font(.system(size: 16))
                            Text(viewModel.place)
                                .font(AppTheme.regularFont(size: .subheadline))
                        }
                    }
                    Spacer()
                }
                VStack(spacing: -4) {
                    HStack {
                        Text(viewModel.temperature)
                            .font(AppTheme.boldFont(size: .largeTitle))
                        if let url = viewModel.iconUrl {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                        }
                    }
                    Text(viewModel.weatherDescription)
                        .font(AppTheme.regularFont(size: .small))
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

private struct MockGetLocationUseCase: GetLocationUseCase {
    func execute() async throws -> CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: 40.123432452, longitude: -3.3243534)
    }
}

#Preview {
    let mockLocationUseCase = MockGetLocationUseCase()
    let mockUseCase = MockGetWeatherUseCase()
    let viewModel = HomeViewModel(getLocationUseCase: mockLocationUseCase, getWeatherUseCase: mockUseCase)
    HomeView(viewModel: viewModel)
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
