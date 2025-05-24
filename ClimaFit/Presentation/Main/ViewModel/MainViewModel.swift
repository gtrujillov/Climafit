//
//  MainViewModel.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import Foundation

enum MainTab: Int, CaseIterable {
    case home, search, settings

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape.fill"
        }
    }
}

final class MainViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .home
}
