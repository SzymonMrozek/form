import Foundation

enum FormPhotoPickerViewCoordination {
    case pickPhoto((URL?) -> Void)
    case didFailToUploadPhoto(PresentableError)
}

// sourcery: AutoMockable
protocol FormPhotoPickerViewModelBuilding {
    func buildViewModel(
        photoSectionMetadata: FormMetadata.PhotoSection,
        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void
    ) -> FormSectionViewModel
}

struct FormPhotoPickerViewModelBuilder {
    private let formModelController: FormModelControlling
    private let cancellableStore = CancellableStore()
    
    init(formModelController: FormModelControlling) {
        self.formModelController = formModelController
    }

    func buildViewModel(
        photoSectionMetadata: FormMetadata.PhotoSection,
        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void
    ) -> FormSectionViewModel {
        return FormSectionViewModel(
            title: photoSectionMetadata.title,
            selection: .none,
            subSectionViewModel: .photos({ updates in
                return FormPhotoPickerViewModel(
                    cells: self.buildPhotoCells(
                        maxCount: photoSectionMetadata.maxCount,
                        updates: updates,
                        coordination: coordination
                    )
                )
            })
        )
    }
    
    private func buildPhotoCells(
        maxCount: Int,
        updates: FormPhotoPickerViewUpdates,
        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void
    ) -> [FormPhotoPickerViewModel.CellViewModel] {
        let currentPhotos = formModelController.currentlyFilledForm.photos
            .map(FormPhotoPickerViewModel.CellViewModel.photo)
        let newPhoto: FormPhotoPickerViewModel.CellViewModel? = {
            guard currentPhotos.count < maxCount else { return nil }
            return newPhotoCellViewModel(
                maxCount: maxCount,
                updates: updates,
                coordination: coordination
            )
        }()
        return currentPhotos + [newPhoto].compactMap { $0 }
    }
    
    private func newPhotoCellViewModel(
        maxCount: Int,
        updates: FormPhotoPickerViewUpdates,
        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void
    ) -> FormPhotoPickerViewModel.CellViewModel {
        return .addNew({ [weak updates] in
            coordination(.pickPhoto({ url in
                guard let url = url else { return }
                self.formModelController.uploadPhoto(url: url, completion: {
                    switch $0 {
                    case .success(let url):
                        self.formModelController.commitFormEdition(.addPhoto(url))
                        guard let updates = updates else { return }
                        let updatedCells = self.buildPhotoCells(
                            maxCount: maxCount,
                            updates: updates,
                            coordination: coordination
                        )
                        updates.updateWithCells(cells: updatedCells)
                    case .failure(let error):
                        coordination(.didFailToUploadPhoto(error))
                    }
                }).store(in: self.cancellableStore)
            }))
        })
    }
}
