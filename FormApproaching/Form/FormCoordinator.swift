import Foundation
import UIKit

struct FormCoordinator {
    private let navigationController: UINavigationController
    private let controllersBuilder: ControllersBuilding
    
    init(
        navigationController: UINavigationController,
        controllersBuilder: ControllersBuilding
    ) {
        self.navigationController = navigationController
        self.controllersBuilder = controllersBuilder
    }
    
    func start() {
        let initialViewController = controllersBuilder.buildFormViewController(coordination: {
            switch $0 {
            case .pickPhoto(let pickPhotoCallback):
                self.showPhotoPicker(callback: pickPhotoCallback)
            case .didFailToUploadPhoto:
                fatalError()
            }
        })
        navigationController.setViewControllers([initialViewController], animated: false)
    }
    
    private func push(viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func present(viewController: UIViewController) {
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func showPhotoPicker(callback: @escaping (URL?) -> Void) {
        present(
            viewController: controllersBuilder.buildPhotoPickerViewController(coordination: {
                switch $0 {
                case .selected(let url):
                    callback(url)
                    self.navigationController.dismiss(animated: true)
                }
            })
        )
    }
}
