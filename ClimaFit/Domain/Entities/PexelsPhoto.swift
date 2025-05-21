import Foundation

struct PexelsPhoto: Identifiable, Decodable {
    let id: Int
    let url: String
    let photographer: String
    let src: PexelsPhotoSrc
}

struct PexelsPhotoSrc: Decodable {
    let large: String
    let medium: String
    let portrait: String
    let landscape: String
}

struct PexelsResponse: Decodable {
    let photos: [PexelsPhoto]
} 