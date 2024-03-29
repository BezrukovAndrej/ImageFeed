import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 1
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        
        let session = URLSession.shared
        guard let requestPhoto = makeRequest(lastLoadedPage) else { return assertionFailure("Error photo request")}
        let task = session.objectTask(for: requestPhoto) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                for photo in photoResult {
                    self.photos.append(Photo(from: photo))
                }
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                self.lastLoadedPage += 1
            case .failure(let error):
                assertionFailure("Error - \(error)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(_ page: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: DecodingInfo.API.defaultBaseURL)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [.init(name: "page", value: "\(page)")]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("Failed to create token")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if likeTask != nil { return }
        likeTask?.cancel()
        
        let session = URLSession.shared
        guard let likeRequest = makeLikeRequest(photoId, isLike: isLike) else { return assertionFailure("Error like request")}
        
        let task = session.objectTask(for: likeRequest) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            self.likeTask = nil
            switch result {
            case .success(let photoResult):
                let newPhoto = LikedPhoto(likedPhotoResult: photoResult)
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    var photo = self.photos[index]
                    photo.isLiked = newPhoto.likedPhoto.likedByUser
                    self.photos[index] = photo
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.likeTask = task
        task.resume()
    }
    
    private func makeLikeRequest(_ id: String, isLike: Bool) -> URLRequest? {
        var urlComponents = URLComponents(string: DecodingInfo.API.defaultBaseURL)
        urlComponents?.path = "/photos/\(id)/like"
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("Failed to create token")
            return nil
        }
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
