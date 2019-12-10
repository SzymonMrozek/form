import Foundation

// Just for satisfying protocol
struct AnyCancellable: Cancellable {
    let onCancel: () -> Void
    
    init(_ onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
    }
    
    func cancel() {
        onCancel()
    }
}

// MARK: - API resources
// This interface should be more like, `func perform(request: Request, completion @escaping<Resource, APIError> but in this case it's made for simplifying the app mocking in AppDelegate.swift
protocol ApiResourceProviding {
    func getFormBaseData(
        completion: @escaping (Result<FormBaseDataResponse, URLError>) -> Void
    ) -> Cancellable
    
    func uploadPhoto(
        atURL url: URL,
        completion: @escaping (Result<UploadPhotoResponse, URLError>) -> Void
    ) -> Cancellable
}

struct ApiResourceProviderMock: ApiResourceProviding {
    func getFormBaseData(
        completion: @escaping (Result<FormBaseDataResponse, URLError>) -> Void
    ) -> Cancellable {
        completion(.success(FormBaseDataResponse(photosSectionTitle: "Please add photos below", photosFieldMaxCount: 5)))
        return AnyCancellable { }
    }
    
    func uploadPhoto(
        atURL url: URL,
        completion: @escaping (Result<UploadPhotoResponse, URLError>) -> Void
    ) -> Cancellable {
        completion(.success(UploadPhotoResponse(uploadedURL: url)))
        return AnyCancellable { }
    }
}

// MARK: - Photos provider
// sourcery: AutoMockable
protocol PhotoAlbumProviding {
    func getPhotos(
        completion: @escaping (Result<PhotosResponse, URLError>) -> Void
    ) -> Cancellable
}

struct PhotoAlbumProviderMock: PhotoAlbumProviding {
    func getPhotos(
        completion: @escaping (Result<PhotosResponse, URLError>) -> Void
    ) -> Cancellable {
        completion(.success(PhotosResponse(photosURL: [
            URL(string: "google.com")!,
            URL(string: "facebook.com")!,
            URL(string: "youtube.com")!,
            URL(string: "bing.com")!,
            URL(string: "reddit.com")!
        ])))
        return AnyCancellable { }
    }
}

// MARK: - Protocol composition
protocol HasApiResourceProviding {
    var apiResourceProviding: ApiResourceProviding { get }
}

// sourcery: AutoMockable
protocol HasPhotoAlbumProviding {
    var photoAlbumProviding: PhotoAlbumProviding { get }
}

// MARK: - Dependency container
struct GlobalDependencies {
    let apiResourceProviding: ApiResourceProviding
    let photoAlbumProviding: PhotoAlbumProviding
    
    init() {
        apiResourceProviding = ApiResourceProviderMock()
        photoAlbumProviding = PhotoAlbumProviderMock()
    }
}

extension GlobalDependencies: HasApiResourceProviding { }
extension GlobalDependencies: HasPhotoAlbumProviding { }
