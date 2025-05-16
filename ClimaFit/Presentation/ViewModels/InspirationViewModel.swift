import Foundation
import Combine

class InspirationViewModel: ObservableObject {
    @Published var photos: [PexelsPhoto] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var selectedPhoto: PexelsPhoto?
    
    private let pexelsAPI: PexelsAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(pexelsAPI: PexelsAPIProtocol) {
        self.pexelsAPI = pexelsAPI
    }
    
    func fetchInspiration(query: String) {
        isLoading = true
        error = nil
        photos = []
        selectedPhoto = nil
        
        pexelsAPI.fetchPhotos(query: query, perPage: 20)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
                self?.selectRandomPhoto()
            }
            .store(in: &cancellables)
    }
    
    func selectRandomPhoto() {
        guard !photos.isEmpty else { selectedPhoto = nil; return }
        selectedPhoto = photos.randomElement()
    }
} 
