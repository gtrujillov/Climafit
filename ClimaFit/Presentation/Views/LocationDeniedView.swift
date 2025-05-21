import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "location.slash.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(AppTheme.prussianBlue)
                .padding(.bottom, 8)
            
            Text("Acceso a ubicación denegado")
                .font(AppTheme.subtitleFont)
                .foregroundColor(.primary)
            
            Text("Para mostrarte el clima y recomendaciones de ropa, necesitamos acceder a tu ubicación. Por favor, habilita el acceso en la configuración de tu dispositivo.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(AppTheme.bodyFont)
                .padding(.horizontal)
            
            Spacer()
            
            PillButton(title: "Abrir Configuración") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .background(AppTheme.background.ignoresSafeArea())
    }
} 
