import SwiftUI

struct ClothingRecommendationView: View {
    let temperature: Double
    @State private var outfitPhoto: PexelsPhoto?
    @State private var isLoading = false
    @State private var error: String?
    @State private var showInspiration = false
    
    private var recommendation: (title: String, items: [String]) {
        switch temperature {
        case ...10:
            return ("Outfit invernal recomendado", ["abrigo", "bufanda", "guantes", "gorro", "botas"])
        case 10..<15:
            return ("Outfit para frío", ["chaqueta", "jersey", "pantalón largo", "zapatos cerrados"])
        case 15..<20:
            return ("Outfit de entretiempo", ["sudadera ligera", "camiseta manga larga", "jeans"])
        case 20..<25:
            return ("Outfit primaveral", ["camiseta", "pantalón ligero", "zapatillas"])
        case 25..<30:
            return ("Outfit veraniego", ["camiseta manga corta", "pantalón corto", "sandalias"])
        default:
            return ("Outfit para mucho calor", ["ropa muy ligera", "sombrero", "sandalias", "protector solar"])
        }
    }
    
    private var query: String {
        let base = "outfit fashion streetstyle "
        let items = recommendation.items.joined(separator: " ")
        return base + items
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(recommendation.title)
                .font(.title3).bold()
                .foregroundColor(AppTheme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Prendas sugeridas:")
                        .padding(.bottom, 5)
                        .font(.footnote)
                        .foregroundColor(.primary)
                    ForEach(recommendation.items, id: \.self) { item in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.purple)
                            Text(item.capitalized)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                Spacer()
            }
            if isLoading {
                ProgressView("Buscando outfit ideal...")
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.accent))
                    .scaleEffect(1.2)
            } else if let error {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else if let photo = outfitPhoto {
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: photo.src.portrait)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 320)
                                    .clipped()
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .transition(.opacity.combined(with: .scale))
                            case .failure:
                                Color.gray.opacity(0.1)
                                    .frame(height: 320)
                                    .cornerRadius(AppTheme.cornerRadius)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        Button(action: {
                            if let url = URL(string: photo.url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "link.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppTheme.accent)
                                .shadow(radius: 4)
                                .padding(12)
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 0)
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: photo.id)
            }
            NavigationLink(destination: InspirationView(query: query), isActive: $showInspiration) {
                EmptyView()
            }
            PillButton(title: "Ver más inspiración de outfits") {
                showInspiration = true
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadius)
        .shadow(color: AppTheme.shadow, radius: 12, x: 0, y: 6)
        .frame(maxWidth: .infinity)
        .onAppear {
            fetchOutfitPhoto()
        }
    }
    
    private func fetchOutfitPhoto() {
        isLoading = true
        error = nil
        let pexelsAPI = PexelsAPI(apiKey: Config.pexelsAPIKey)
        pexelsAPI.searchPhotos(query: query) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let photos):
                    outfitPhoto = photos.first
                case .failure(let err):
                    error = err.localizedDescription
                }
            }
        }
    }
}

struct ClothingRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingRecommendationView(temperature: 24)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
 
