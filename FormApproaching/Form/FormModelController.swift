import Foundation

struct FormData {
    struct PhotoSectionMeta {
        let maxCount: Int
        let title: String
    }
    
    let photoSection: PhotoSectionMeta
}

enum GetFormError: Error, PresentableError {
    case unknown
}

enum FormUploadPhotoError: Error, PresentableError {
    case unknown
}

// sourcery: AutoMockable
protocol FormModelControlling {
    func getFormData(
        completion: @escaping (Result<FormData, GetFormError>) -> Void
    ) -> Cancellable
    
    func uploadPhoto(
        url: URL,
        completion: @escaping (Result<URL, FormUploadPhotoError>) -> Void
    ) -> Cancellable
}

struct FormModelController: FormModelControlling {
    private let apiResourceProviding: ApiResourceProviding
    
    init(
        apiResourceProviding: ApiResourceProviding
    ) {
        self.apiResourceProviding = apiResourceProviding
    }
    
    func getFormData(
        completion: @escaping (Result<FormData, GetFormError>) -> Void
    ) -> Cancellable {
        return apiResourceProviding.getFormBaseData(
            completion: {
                switch $0 {
                case .success(let response):
                    let model = FormData(
                        photoSection: FormData.PhotoSectionMeta(
                            maxCount: response.photosFieldMaxCount,
                            title: response.photosSectionTitle
                        )
                    )
                    completion(.success(model))
                case .failure:
                    completion(.failure(.unknown))
                }
            }
        )
    }
    
    func uploadPhoto(
        url: URL,
        completion: @escaping (Result<URL, FormUploadPhotoError>) -> Void
    ) -> Cancellable {
        return apiResourceProviding.uploadPhoto(
            atURL: URL(string: "https://www.google.com")!,
            completion: {
                switch $0 {
                case .success(let response):
                    completion(.success(response.uploadedURL))
                case .failure:
                    completion(.failure(.unknown))
                }
            }
        )
    }
}

