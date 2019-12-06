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

    //MARK: - getFormData

    var getFormDataCompletionCallsCount = 0
    var getFormDataCompletionCalled: Bool {
        return getFormDataCompletionCallsCount > 0
    }
    var getFormDataCompletionReceivedCompletion: ((Result<FormModel, GetFormError>) -> Void)?
    var getFormDataCompletionReturnValue: Cancellable!
    var getFormDataCompletionClosure: ((@escaping (Result<FormModel, GetFormError>) -> Void) -> Cancellable)?

    func getFormData(        completion: @escaping (Result<FormModel, GetFormError>) -> Void    ) -> Cancellable {
        getFormDataCompletionCallsCount += 1
        getFormDataCompletionReceivedCompletion = completion
        return getFormDataCompletionClosure.map({ $0(completion) }) ?? getFormDataCompletionReturnValue
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

}
class FormPhotoPickerViewModelBuildingMock: FormPhotoPickerViewModelBuilding {

    //MARK: - buildViewModel

    var buildViewModelPhotoSectionMetaCoordinationCallsCount = 0
    var buildViewModelPhotoSectionMetaCoordinationCalled: Bool {
        return buildViewModelPhotoSectionMetaCoordinationCallsCount > 0
    }
    var buildViewModelPhotoSectionMetaCoordinationReceivedArguments: (photoSectionMeta: FormModel.PhotoSectionMeta, coordination: (FormPhotoPickerViewCoordination) -> Void)?
    var buildViewModelPhotoSectionMetaCoordinationReturnValue: FormSectionViewModel!
    var buildViewModelPhotoSectionMetaCoordinationClosure: ((FormModel.PhotoSectionMeta, @escaping (FormPhotoPickerViewCoordination) -> Void) -> FormSectionViewModel)?

    func buildViewModel(        photoSectionMeta: FormModel.PhotoSectionMeta,        coordination: @escaping (FormPhotoPickerViewCoordination) -> Void    ) -> FormSectionViewModel {
        buildViewModelPhotoSectionMetaCoordinationCallsCount += 1
        buildViewModelPhotoSectionMetaCoordinationReceivedArguments = (photoSectionMeta: photoSectionMeta, coordination: coordination)
        return buildViewModelPhotoSectionMetaCoordinationClosure.map({ $0(photoSectionMeta, coordination) }) ?? buildViewModelPhotoSectionMetaCoordinationReturnValue
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
