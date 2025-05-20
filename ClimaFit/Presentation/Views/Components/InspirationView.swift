import SwiftUI

struct InspirationView: View {
    let query: String
    @StateObject private var viewModel: InspirationViewModel
    
    init(query: String) {
        let pexelsAPI = PexelsAPI(apiKey: Config.pexelsAPIKey)
        _viewModel = StateObject(wrappedValue: InspirationViewModel(pexelsAPI: pexelsAPI))
        self.query = query
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 32) {
                Text("Inspiración")
                    .font(.largeTitle).bold()
                    .foregroundColor(AppTheme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                Spacer()
                if viewModel.isLoading {
                    ProgressView("Buscando inspiración…")
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.accent))
                        .scaleEffect(1.3)
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(AppTheme.cardBackground))
                        .shadow(color: AppTheme.shadow, radius: 16, x: 0, y: 8)
                } else if let photo = viewModel.selectedPhoto {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: photo.src.portrait)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 340)
                                    .clipped()
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .transition(.opacity.combined(with: .scale))
                            case .failure:
                                Color.gray.opacity(0.1)
                                    .frame(height: 340)
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
                    .frame(maxWidth: 420)
                    .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(AppTheme.cardBackground))
                    .shadow(color: AppTheme.shadow, radius: 16, x: 0, y: 8)
                    .padding(.horizontal, 8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: photo.id)
                    PillButton(title: "Ver otra inspiración") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            viewModel.selectRandomPhoto()
                        }
                    }
                    .padding(.top, 8)
                } else {
                    Text("No se encontró inspiración para tu búsqueda")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(AppTheme.cardBackground))
                        .shadow(color: AppTheme.shadow, radius: 16, x: 0, y: 8)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            viewModel.fetchInspiration(query: query)
        }
    }
}

struct InspirationPhotoCardModern: View {
    let photo: PexelsPhoto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: photo.src.portrait)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.gray.opacity(0.12))
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 260)
                            .clipped()
                            .cornerRadius(24, corners: [.topLeft, .topRight])
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.18)]), startPoint: .center, endPoint: .bottom)
                                    .cornerRadius(24, corners: [.topLeft, .topRight])
                            )
                    case .failure:
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.gray.opacity(0.12))
                            .overlay(Text("No disponible").foregroundColor(.gray))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 260)
                .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)
                
                Button(action: {
                    if let url = URL(string: photo.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(10)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(photo.photographer)
                    .font(.headline)
                    .foregroundColor(.primary)
                Button(action: {
                    if let url = URL(string: photo.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Ver en Pexels")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)
        )
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .animation(.spring(), value: photo.id)
    }
}

// Extensión para esquinas específicas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
