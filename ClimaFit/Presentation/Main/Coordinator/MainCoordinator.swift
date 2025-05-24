//
//  MainCoordinator.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import Foundation
import SwiftUI

final class MainCoordinator {
    @MainActor
    func view(for tab: MainTab) -> some View {
        switch tab {
        case .home:
            return HomeCoordinatorImpl().start()
        case .search:
            return AnyView(Text("🔍 Buscar").font(.title))
        case .settings:
            return AnyView(Text("⚙️ Ajustes").font(.title))
        }
    }
}
