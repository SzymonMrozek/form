// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import FormApproaching













class CancellableMock: Cancellable {

    //MARK: - cancel

    var cancelCallsCount = 0
    var cancelCalled: Bool {
        return cancelCallsCount > 0
    }
    var cancelClosure: (() -> Void)?

    func cancel() {
        cancelCallsCount += 1
        cancelClosure?()
    }

}
class FormModelControllingMock: FormModelControlling {
    var currentlyFilledForm: FilledForm {
        get { return underlyingCurrentlyFilledForm }
        set(value) { underlyingCurrentlyFilledForm = value }
    }
    var underlyingCurrentlyFilledForm: FilledForm!

    //MARK: - getFormMetadata

    var getFormMetadataCompletionCallsCount = 0
    var getFormMetadataCompletionCalled: Bool {
        return getFormMetadataCompletionCallsCount > 0
    }
    var getFormMetadataCompletionReceivedCompletion: ((Result<FormMetadata, GetFormError>) -> Void)?
    var getFormMetadataCompletionReturnValue: Cancellable!
    var getFormMetadataCompletionClosure: ((@escaping (Result<FormMetadata, GetFormError>) -> Void) -> Cancellable)?

    func getFormMetadata(        completion: @escaping (Result<FormMetadata, GetFormError>) -> Void    ) -> Cancellable {
        getFormMetadataCompletionCallsCount += 1
        getFormMetadataCompletionReceivedCompletion = completion
        return getFormMetadataCompletionClosure.map({ $0(completion) }) ?? getFormMetadataCompletionReturnValue
    }

    //MARK: - uploadPhoto

    var uploadPhotoUrlCompletionCallsCount = 0
    var uploadPhotoUrlCompletionCalled: Bool {
        return uploadPhotoUrlCompletionCallsCount > 0
    }
    var uploadPhotoUrlCompletionReceivedArguments: (url: URL, completion: (Result<URL, FormUploadPhotoError>) -> Void)?
    var uploadPhotoUrlCompletionReturnValue: Cancellable!
    var uploadPhotoUrlCompletionClosure: ((URL, @escaping (Result<URL, FormUploadPhotoError>) -> Void) -> Cancellable)?

    func uploadPhoto(        url: URL,        completion: @escaping (Result<URL, FormUploadPhotoError>) -> Void    ) -> Cancellable {
        uploadPhotoUrlCompletionCallsCount += 1
        uploadPhotoUrlCompletionReceivedArguments = (url: url, completion: completion)
        return uploadPhotoUrlCompletionClosure.map({ $0(url, completion) }) ?? uploadPhotoUrlCompletionReturnValue
    }

    //MARK: - commitFormEdition

    var commitFormEditionCallsCount = 0
    var commitFormEditionCalled: Bool {
        return commitFormEditionCallsCount > 0
    }
    var commitFormEditionReceivedEdition: FormEdition?
    var commitFormEditionClosure: ((FormEdition) -> Void)?

    func commitFormEdition(_ edition: FormEdition) {
        commitFormEditionCallsCount += 1
        commitFormEditionReceivedEdition = edition
        commitFormEditionClosure?(edition)
    }

}
class FormPhotoPickerViewModelBuildingMock: FormPhotoPickerViewModelBuilding {

    //MARK: - buildViewModel

    var buildViewModelPhotoSectionMetadataCoordinationCallsCount = 0
    var buildViewModelPhotoSectionMetadataCoordinationCalled: Bool {
        return buildViewModelPhotoSectionMetadataCoordinationCallsCount > 0
    }
    var buildViewModelPhotoSectionMetadataCoordinationReceivedArguments: (photoSectionMetadata: FormMetadata.PhotoSection, coordination: (FormPhotoPickerViewCoordination) -> Void)?
    var buildViewModelPhotoSectionMetadataCoordinationReturnValue: FormSectionViewModel!
    var buildViewModelPhotoSectionMetadataCoordinationClosure: ((FormMetadata.PhotoSection, @escaping (FormPhotoPickerViewCoordination) -> Void) -> FormSectionViewModel)?

    func buildViewModel(        photoSectionMetadata: FormMetadata.PhotoSection,        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void    ) -> FormSectionViewModel {
        buildViewModelPhotoSectionMetadataCoordinationCallsCount += 1
        buildViewModelPhotoSectionMetadataCoordinationReceivedArguments = (photoSectionMetadata: photoSectionMetadata, coordination: coordination)
        return buildViewModelPhotoSectionMetadataCoordinationClosure.map({ $0(photoSectionMetadata, coordination) }) ?? buildViewModelPhotoSectionMetadataCoordinationReturnValue
    }

}
class FormPhotoPickerViewUpdatesMock: FormPhotoPickerViewUpdates {

    //MARK: - updateWithCells

    var updateWithCellsCellsCallsCount = 0
    var updateWithCellsCellsCalled: Bool {
        return updateWithCellsCellsCallsCount > 0
    }
    var updateWithCellsCellsReceivedCells: [FormPhotoPickerViewModel.CellViewModel]?
    var updateWithCellsCellsClosure: (([FormPhotoPickerViewModel.CellViewModel]) -> Void)?

    func updateWithCells(cells: [FormPhotoPickerViewModel.CellViewModel]) {
        updateWithCellsCellsCallsCount += 1
        updateWithCellsCellsReceivedCells = cells
        updateWithCellsCellsClosure?(cells)
    }

}
class FormViewModelBuildingMock: FormViewModelBuilding {

    //MARK: - buildViewModel

    var buildViewModelUpdatesCallsCount = 0
    var buildViewModelUpdatesCalled: Bool {
        return buildViewModelUpdatesCallsCount > 0
    }
    var buildViewModelUpdatesReceivedUpdates: FormViewUpdates?
    var buildViewModelUpdatesReturnValue: FormViewModel!
    var buildViewModelUpdatesClosure: ((FormViewUpdates) -> FormViewModel)?

    func buildViewModel(updates: FormViewUpdates) -> FormViewModel {
        buildViewModelUpdatesCallsCount += 1
        buildViewModelUpdatesReceivedUpdates = updates
        return buildViewModelUpdatesClosure.map({ $0(updates) }) ?? buildViewModelUpdatesReturnValue
    }

}
class FormViewUpdatesMock: FormViewUpdates {

    //MARK: - update

    var updateWithCallsCount = 0
    var updateWithCalled: Bool {
        return updateWithCallsCount > 0
    }
    var updateWithReceivedSections: [FormSectionViewModel]?
    var updateWithClosure: (([FormSectionViewModel]) -> Void)?

    func update(with sections: [FormSectionViewModel]) {
        updateWithCallsCount += 1
        updateWithReceivedSections = sections
        updateWithClosure?(sections)
    }

}
class HasPhotoAlbumProvidingMock: HasPhotoAlbumProviding {
    var photoAlbumProviding: PhotoAlbumProviding {
        get { return underlyingPhotoAlbumProviding }
        set(value) { underlyingPhotoAlbumProviding = value }
    }
    var underlyingPhotoAlbumProviding: PhotoAlbumProviding!

}
class PhotoAlbumProvidingMock: PhotoAlbumProviding {

    //MARK: - getPhotos

    var getPhotosCompletionCallsCount = 0
    var getPhotosCompletionCalled: Bool {
        return getPhotosCompletionCallsCount > 0
    }
    var getPhotosCompletionReceivedCompletion: ((Result<PhotosResponse, URLError>) -> Void)?
    var getPhotosCompletionReturnValue: Cancellable!
    var getPhotosCompletionClosure: ((@escaping (Result<PhotosResponse, URLError>) -> Void) -> Cancellable)?

    func getPhotos(        completion: @escaping (Result<PhotosResponse, URLError>) -> Void    ) -> Cancellable {
        getPhotosCompletionCallsCount += 1
        getPhotosCompletionReceivedCompletion = completion
        return getPhotosCompletionClosure.map({ $0(completion) }) ?? getPhotosCompletionReturnValue
    }

}
class PhotoPickerTableViewUpdatesMock: PhotoPickerTableViewUpdates {

    //MARK: - update

    var updateWithCallsCount = 0
    var updateWithCalled: Bool {
        return updateWithCallsCount > 0
    }
    var updateWithReceivedCells: [PhotoPickerCellViewModel]?
    var updateWithClosure: (([PhotoPickerCellViewModel]) -> Void)?

    func update(with cells: [PhotoPickerCellViewModel]) {
        updateWithCallsCount += 1
        updateWithReceivedCells = cells
        updateWithClosure?(cells)
    }

}
class PhotoPickerViewModelBuildingMock: PhotoPickerViewModelBuilding {

    //MARK: - buildViewModel

    var buildViewModelUpdatesCallsCount = 0
    var buildViewModelUpdatesCalled: Bool {
        return buildViewModelUpdatesCallsCount > 0
    }
    var buildViewModelUpdatesReceivedUpdates: PhotoPickerTableViewUpdates?
    var buildViewModelUpdatesReturnValue: PhotoPickerTableViewModel!
    var buildViewModelUpdatesClosure: ((PhotoPickerTableViewUpdates) -> PhotoPickerTableViewModel)?

    func buildViewModel(updates: PhotoPickerTableViewUpdates) -> PhotoPickerTableViewModel {
        buildViewModelUpdatesCallsCount += 1
        buildViewModelUpdatesReceivedUpdates = updates
        return buildViewModelUpdatesClosure.map({ $0(updates) }) ?? buildViewModelUpdatesReturnValue
    }

}
