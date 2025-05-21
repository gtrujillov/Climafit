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
        VStack(spacing: 5) {
            HStack {
                Text(value)
                    .font(AppTheme.carosSoftFont(.bold, size: 16))
                    .bold()
                    .foregroundColor(AppTheme.prussianBlue)
                Image(systemName: icon)
                    .font(AppTheme.carosSoftFont(.bold, size: 14))
                    .foregroundColor(AppTheme.prussianBlue)
            }
            Text(title)
                .font(AppTheme.carosSoftFont(.light, size: 12))
                .foregroundColor(AppTheme.indigoDye1)
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
