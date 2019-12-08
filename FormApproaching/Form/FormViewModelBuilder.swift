import Foundation

// sourcery: AutoMockable
protocol FormViewModelBuilding {
    func buildViewModel(updates: FormViewUpdates) -> FormViewModel
}

protocol PresentableError {
    
}

enum FormViewCoordination {
    case pickPhoto((URL?) -> Void)
    case didFailToUploadPhoto(PresentableError)
}

struct FormViewModelBuilder: FormViewModelBuilding {
    private let formModelController: FormModelControlling
    private let photoPickerViewModelBuilder: FormPhotoPickerViewModelBuilding
    private let coordination: (FormViewCoordination) -> Void
    private let cancellableStore = CancellableStore()

    init(
        formModelController: FormModelControlling,
        photoPickerViewModelBuilder: FormPhotoPickerViewModelBuilding,
        coordination: @escaping (FormViewCoordination) -> Void
    ) {
        self.formModelController = formModelController
        self.photoPickerViewModelBuilder = photoPickerViewModelBuilder
        self.coordination = coordination
    }
    
    func buildViewModel(updates: FormViewUpdates) -> FormViewModel {
        formModelController.getFormMetadata(completion: { result in
            switch result {
            case .success(let metadata):
                let sections = self.buildSections(basedOnFormMetadata: metadata)
                updates.update(with: sections)
            case .failure:
                updates.update(with: [])
            }
        })
        .store(in: cancellableStore)
        
        return FormViewModel(sections: [])
    }
    
    private func buildSections(
        basedOnFormMetadata formMetadata: FormMetadata
    ) -> [FormSectionViewModel] {
        return [
            photoPickerSection(photoSectionMetadata: formMetadata.photoSection)
        ]
    }
    
    private func photoPickerSection(
        photoSectionMetadata: FormMetadata.PhotoSection
    ) -> FormSectionViewModel {
        return photoPickerViewModelBuilder.buildViewModel(
            photoSectionMetadata: photoSectionMetadata,
            coordination: {
                switch $0 {
                case .pickPhoto(let block):
                    self.coordination(.pickPhoto(block))
                case .didFailToUploadPhoto(let error):
                    self.coordination(.didFailToUploadPhoto(error))
                }
            }
        )
    }
}
