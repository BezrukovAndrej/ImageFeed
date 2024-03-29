import Foundation

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}
