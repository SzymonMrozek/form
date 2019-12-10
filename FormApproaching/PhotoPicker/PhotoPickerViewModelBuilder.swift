import Foundation

protocol PhotoPickerViewModelBuilding {
    func buildViewModel(updates: PhotoPickerTableViewUpdates) -> PhotoPickerTableViewModel
}

enum PhotoPickerViewCoordination {
    case selected(URL)
}

struct PhotoPickerTableViewModelBuilder: PhotoPickerViewModelBuilding {
    private let photoAlbumProvider: PhotoAlbumProviding
    private let coordination: (PhotoPickerViewCoordination) -> Void
    private let cancellableStore = CancellableStore()

    init(
        photoAlbumProvider: PhotoAlbumProviding,
        coordination: @escaping (PhotoPickerViewCoordination) -> Void
    ) {
        self.photoAlbumProvider = photoAlbumProvider
        self.coordination = coordination
    }
    
    func buildViewModel(updates: PhotoPickerTableViewUpdates)
        -> PhotoPickerTableViewModel {
            photoAlbumProvider.getPhotos { result in
                switch result {
                case .success(let data):
                    let cellViewModels = data.photosURL.map { PhotoPickerCellViewModel(url: $0) }
                    updates.update(with: cellViewModels)
                case .failure:
                    updates.update(with: [])
                }
            }
            .store(in: cancellableStore)
            
            return PhotoPickerTableViewModel(cells: []) { url in
                self.coordination(.selected(url))
            }
    }    
}
