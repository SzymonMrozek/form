import Foundation

// sourcery: AutoMockable
protocol PhotoPickerViewModelBuilding {
    func buildViewModel(updates: PhotoPickerTableViewUpdates) -> PhotoPickerTableViewModel
}

enum PhotoPickerViewCoordination {
    case selected(URL)
}

struct PhotoPickerTableViewModelBuilder: PhotoPickerViewModelBuilding {
    typealias Dependencies = HasPhotoAlbumProviding
    private let dependencies: Dependencies
    private let coordination: (PhotoPickerViewCoordination) -> Void
    private let cancellableStore = CancellableStore()

    init(
        dependencies: Dependencies,
        coordination: @escaping (PhotoPickerViewCoordination) -> Void
    ) {
        self.dependencies = dependencies
        self.coordination = coordination
    }
    
    func buildViewModel(updates: PhotoPickerTableViewUpdates)
        -> PhotoPickerTableViewModel {
            dependencies.photoAlbumProviding.getPhotos(completion: { result in
                switch result {
                case .success(let response):
                    let models = response.photosURL.map { PhotoPickerCellViewModel(url: $0) }
                    updates.update(with: models)
                case .failure:
                    updates.update(with: [])
                }
            })
            .store(in: cancellableStore)
            
            return PhotoPickerTableViewModel(cells: [], didSelectPhoto: { url in
                self.coordination(.selected(url))
            })
    }
}


