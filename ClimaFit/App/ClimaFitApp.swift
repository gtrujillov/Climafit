import SwiftUI

@main
struct ClimaFitApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
