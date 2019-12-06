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
        let formEditor = FormEditor()
        let viewModelBuilder = FormViewModelBuilder(
            formModelController: formModelController,
            photoPickerViewModelBuilder: FormPhotoPickerViewModelBuilder(
                formModelController: formModelController,
                formEditor: formEditor
            ),
            coordination: coordination
        )
        return FormViewController(viewModelBuilder: viewModelBuilder)
    }

    func buildPhotoPickerViewController(
        coordination: (PhotoPickerViewCoordination) -> Void
    ) -> UIViewController {
        // ------ this is just a test
        coordination(.selected(URL(string: "https://google.com")!))
        let controller =  UIViewController(nibName: nil, bundle: nil)
        controller.loadViewIfNeeded()
        controller.view.backgroundColor = .white
        return controller
    }

}

// ------ this is just a test
enum PhotoPickerViewCoordination {
    case selected(URL)
    case cancelled
}
