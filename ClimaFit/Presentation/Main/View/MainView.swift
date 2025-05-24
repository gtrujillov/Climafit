//
//  Main.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    private let coordinator = MainCoordinator()

    var body: some View {
        ZStack(alignment: .bottom) {
            coordinator.view(for: viewModel.selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground).ignoresSafeArea())

            FloatingTabBarView(selectedTab: $viewModel.selectedTab)
        }
    }
}

#Preview {
    MainView()
}
