import Foundation

struct FormMetadata {
    struct PhotoSection {
        let maxCount: Int
        let title: String
    }
    
    let photoSection: PhotoSection
}

enum GetFormError: Error, PresentableError {
    case unknown
}

enum FormUploadPhotoError: Error, PresentableError {
    case unknown
}

// sourcery: AutoMockable
protocol FormModelControlling {
    var currentlyFilledForm: FilledForm { get }
    
    func getFormMetadata(
        completion: @escaping (Result<FormMetadata, GetFormError>) -> Void
    ) -> Cancellable
    
    func uploadPhoto(
        url: URL,
        completion: @escaping (Result<URL, FormUploadPhotoError>) -> Void
    ) -> Cancellable
    
    func commitFormEdition(_ edition: FormEdition)
}

final class FormModelController: FormModelControlling {
    private let apiResourceProviding: ApiResourceProviding
    private(set) var currentlyFilledForm: FilledForm = FilledForm(
        photos: []
    )
    
    init(
        apiResourceProviding: ApiResourceProviding,
        formEditor: (inout FilledForm, FormEdition) -> Void = formEditor
    ) {
        self.apiResourceProviding = apiResourceProviding
    }
    
    func getFormMetadata(
        completion: @escaping (Result<FormMetadata, GetFormError>) -> Void
    ) -> Cancellable {
        return apiResourceProviding.getFormBaseData(
            completion: {
                switch $0 {
                case .success(let response):
                    let model = FormMetadata(
                        photoSection: FormMetadata.PhotoSection(
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
    
    func commitFormEdition(_ edition: FormEdition) {
        formEditor(form: &currentlyFilledForm, edition: edition)
        saveOnDisk()
    }
    
    private func saveOnDisk() {
        // ....
    }
}

func formEditor(form: inout FilledForm, edition: FormEdition) -> Void {
    switch edition {
    case .addPhoto(let url): form.photos.append(url)
    }
}
