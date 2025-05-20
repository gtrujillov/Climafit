//
//  WeatherDetailItem.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 20/5/25.
//

import SwiftUI

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(AppTheme.accent)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct WeatherDetailItem_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailItem(
            icon: "wind",
            value: "10 km/h",
            title: "Viento"
        )
    }
}
