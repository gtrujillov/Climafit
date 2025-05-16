import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(AppTheme.accent)
                .padding(.bottom, 8)
            
            Text("Bienvenido a ClimaFit")
                .font(AppTheme.titleFont)
                .foregroundColor(.primary)
            
            Text("Para mostrarte el clima y recomendaciones de ropa, necesitamos acceder a tu ubicación.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(AppTheme.bodyFont)
                .padding(.horizontal)
            
            Spacer()
            
            PillButton(title: "Permitir acceso a ubicación") {
                locationManager.requestPermission()
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .background(AppTheme.background.ignoresSafeArea())
    }
} 