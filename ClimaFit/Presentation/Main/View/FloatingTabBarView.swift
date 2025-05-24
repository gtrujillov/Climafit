//
//  FloatingTabBarView.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 24/5/25.
//

import SwiftUI

struct FloatingTabBarView: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        HStack {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Spacer()
                Button(action: {
                    selectedTab = tab
                }) {
                    Image(systemName: tab.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                        .foregroundColor(selectedTab == tab ? AppTheme.primaryBrown: .gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

#Preview {
    @Previewable @State var selectedTab: MainTab = .home
    return FloatingTabBarView(selectedTab: $selectedTab)
}
