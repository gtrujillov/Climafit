//
//  SearchBarView.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 21/5/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var placeholder: String = "Search city..."
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $searchText)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .submitLabel(.search)

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: AppTheme.shadow, radius: 12, x: 0, y: 6)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
