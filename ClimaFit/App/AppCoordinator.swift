//
//  AppCoordinator.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    func start() -> some View {
        HomeCoordinatorImpl().start()
    }
}
