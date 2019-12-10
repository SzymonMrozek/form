import Foundation
import UIKit

protocol ControllersBuilding {
    func buildFormViewController(
        coordination: @escaping (FormViewCoordination) -> Void
    ) -> UIViewController
    
    func buildPhotoPickerViewController(
        coordination: @escaping (PhotoPickerViewCoordination) -> Void
    ) -> UIViewController
}

struct ControllersBuilder: ControllersBuilding {
    private let dependencies: GlobalDependencies
    
    init(dependencies: GlobalDependencies) {
        self.dependencies = dependencies
    }
    
    func buildFormViewController(
        coordination: @escaping (FormViewCoordination) -> Void
    ) -> UIViewController {
        let formModelController = FormModelController(
            apiResourceProviding: dependencies.apiResourceProviding
        )
        let viewModelBuilder = FormViewModelBuilder(
            formModelController: formModelController,
            formPhotoPickerViewModelBuilder: FormPhotoPickerViewModelBuilder(
                formModelController: formModelController
            ),
            coordination: coordination
        )
        return FormViewController(viewModelBuilder: viewModelBuilder)
    }

    func buildPhotoPickerViewController(
        coordination: @escaping (PhotoPickerViewCoordination) -> Void
    ) -> UIViewController {
        let viewModelBuilder = PhotoPickerTableViewModelBuilder(
            photoAlbumProvider: dependencies.photoAlbumProviding,
            coordination: coordination
        )
        return PhotoPickerViewController(viewModelBuilder: viewModelBuilder)
    }

}
