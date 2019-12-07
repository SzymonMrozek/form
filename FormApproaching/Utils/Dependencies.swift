import Foundation

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

protocol HasApiResourceProviding {
    var apiResourceProviding: ApiResourceProviding { get }
}

struct GlobalDependencies: HasApiResourceProviding {
    let apiResourceProviding: ApiResourceProviding
    
    
    init() {
        apiResourceProviding = ApiResourceProviderMock()
    }
}
