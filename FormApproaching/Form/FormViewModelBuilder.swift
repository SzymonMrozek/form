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
    private let photoPickerViewModelBuilder: FormPhotoPickerViewModelBuilder
    private let coordination: (FormViewCoordination) -> Void
    private let cancellableStore = CancellableStore()

    init(
        formModelController: FormModelControlling,
        photoPickerViewModelBuilder: FormPhotoPickerViewModelBuilder,
        coordination: @escaping (FormViewCoordination) -> Void
    ) {
        self.formModelController = formModelController
        self.photoPickerViewModelBuilder = photoPickerViewModelBuilder
        self.coordination = coordination
    }
    
    func buildViewModel(updates: FormViewUpdates) -> FormViewModel {
        formModelController.getFormData(completion: { result in
            switch result {
            case .success(let model):
                let sections = self.buildSections(basedOnFormData: model)
                updates.update(with: sections)
            case .failure:
                fatalError()
            }
        })
        .store(in: cancellableStore)
        
        return FormViewModel(sections: [])
    }
    
    private func buildSections(
        basedOnFormData formData: FormData
    ) -> [FormSectionViewModel] {
        return [
            photoPickerSection(formPhotoSection: formData.photoSection)
        ]
    }
    
    private func photoPickerSection(
        formPhotoSection: FormData.PhotoSectionMeta
    ) -> FormSectionViewModel {
        return photoPickerViewModelBuilder.buildViewModel(
            photoSectionMeta: formPhotoSection,
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
