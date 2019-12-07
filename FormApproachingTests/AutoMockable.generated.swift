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
