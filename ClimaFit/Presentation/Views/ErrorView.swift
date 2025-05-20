//
//  ErrorView.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 20/5/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("¡Ups!")
                    .font(AppTheme.subtitleFont)
                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                PillButton(title: "Reintentar", action: retryAction)
            }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "No se pudo cargar el clima", retryAction: {})
    }
}
