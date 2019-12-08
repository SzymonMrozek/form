import XCTest
@testable import FormApproaching

class FormPhotoPickerViewModelBuilderTests: XCTestCase {
    private var sut: FormPhotoPickerViewModelBuilder!
    private var formModelControllerMock: FormModelControllingMock!
    private var viewUpdatesMock: FormPhotoPickerViewUpdatesMock!
    
    private let urlMock = URL(string: "https://mocked.com")!
    
    override func setUp() {
        super.setUp()
        formModelControllerMock = FormModelControllingMock()
        viewUpdatesMock = FormPhotoPickerViewUpdatesMock()
        
        sut = FormPhotoPickerViewModelBuilder(
            formModelController: formModelControllerMock
        )
    }
    
    override func tearDown() {
        formModelControllerMock.uploadPhotoUrlCompletionReceivedArguments = nil
        formModelControllerMock = nil
        viewUpdatesMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_buildViewModel_ShouldReturnNoPhotosAndAddCell_WhenNoPhotosInCurrentFormVersion() throws {
        // Arrange
        mock()
        
        // Act
        let viewModel = try buildViewModel().photoPickerViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewModel.cells.count, 1)
        XCTAssertEqual(viewModel.cells.photoCellsCount, 0)
    }
    
    func test_buildViewModel_ShouldReturn1PhotoAndAddCell_When1PhotoInCurrentFormVersion() throws {
        // Arrange
        mock(initialForm: FilledForm(photos: [urlMock]))

        
        // Act
        let viewModel = try buildViewModel().photoPickerViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewModel.cells.count, 2)
        XCTAssertEqual(viewModel.cells.photoCellsCount, 1)
    }
    
    func test_buildViewModel_ShouldReturn3PhotoAndNoAddCell_When3PhotoInCurrentFormVersionAndMaximumCountIs3Photos() throws {
        // Arrange
        mock(initialForm: FilledForm(photos: [urlMock, urlMock, urlMock]))
        
        // Act
        let viewModel = try buildViewModel(
            maxPhotos: 3
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewModel.cells.count, 3)
        XCTAssertFalse(viewModel.cells.hasAddNewTypeCell)
    }
    
    func test_buildViewModel_ShouldCommitNewPhoto_WhenNewPhotoAddedViaCoordinationAndUploadedSuccessfully() throws {
        // Arrange
        mock(
            uploadPhotoResult: .success(urlMock),
            formAfterUpdates: FilledForm(photos: [urlMock])
        )
        
        // Act
        try buildViewModel(
            coordinationOnUploadFailed: { _ in XCTFail("Invalid coordination triggered") },
            coordinationPickPhoto: { [urlMock] in $0(urlMock) }
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        .addNewPhotoCell()()

        // Assert
        let cellsReceivedToUpdate = viewUpdatesMock.updateWithCellsCellsReceivedCells ?? []
        XCTAssertEqual(cellsReceivedToUpdate.count, 2)
        XCTAssertEqual(cellsReceivedToUpdate.photoCellsCount, 1)
        XCTAssertEqual(formModelControllerMock.commitFormEditionReceivedEdition, .addPhoto(urlMock))
    }
    
    func test_buildViewModel_ShouldNotCommitNewPhotoAndPresentError_WhenNewPhotoAddedViaCoordinationAndUploadFailed() throws {
        // Arrange
        mock(uploadPhotoResult: .failure(.unknown))
        
        // Act
        var errorCoordinationCalled = false
        try buildViewModel(
            coordinationOnUploadFailed: { _ in errorCoordinationCalled = true },
            coordinationPickPhoto: { [urlMock] in $0(urlMock) }
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        .addNewPhotoCell()()

        // Assert
        XCTAssertTrue(errorCoordinationCalled)
        XCTAssertEqual(viewUpdatesMock.updateWithCellsCellsCallsCount, 0)
        XCTAssertEqual(formModelControllerMock.currentlyFilledForm.photos.count, 0)
    }
    
    func test_buildViewModel_ShouldDoNothing_WhenNewPhotoAdditionCancelled() throws {
        // Arrange
        mock()
        
        // Act
        try buildViewModel(
            coordinationOnUploadFailed: { _ in XCTFail("Invalid coordination triggered") },
            coordinationPickPhoto: { $0(nil) }
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        .addNewPhotoCell()()

        // Assert
        XCTAssertEqual(viewUpdatesMock.updateWithCellsCellsCallsCount, 0)
        XCTAssertEqual(formModelControllerMock.currentlyFilledForm.photos.count, 0)
    }
    
    func test_deinit_ShouldCancelPhotoUpload_WhenDeinitialized() throws {
        // Arrange
        mock()
        let cancellableMock = CancellableMock()
        formModelControllerMock.uploadPhotoUrlCompletionClosure = { (_,_) in cancellableMock }
        
        // Act
        try buildViewModel(
            coordinationOnUploadFailed: { _ in },
            coordinationPickPhoto: { [urlMock] in $0(urlMock) }
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        .addNewPhotoCell()()
        sut = nil
        formModelControllerMock.uploadPhotoUrlCompletionReceivedArguments = nil
        
        // Assert
        XCTAssertEqual(cancellableMock.cancelCallsCount, 1)
    }
    
    
    private func mock(
        initialForm: FilledForm = FilledForm(photos: []),
        uploadPhotoResult: Result<URL, FormUploadPhotoError>? = nil,
        formAfterUpdates: FilledForm? = nil
    ) {
        formModelControllerMock.currentlyFilledForm = initialForm
        formModelControllerMock.uploadPhotoUrlCompletionClosure = { (_, completion) in
            if let uploadPhotoResult = uploadPhotoResult {
                completion(uploadPhotoResult)
            }
            return CancellableMock()
        }
        formModelControllerMock.commitFormEditionClosure = { [unowned formModelControllerMock] _ in
            formModelControllerMock?.currentlyFilledForm = formAfterUpdates ?? initialForm
        }
    }
    
    private func buildViewModel(
        maxPhotos: Int = 5,
        coordinationOnUploadFailed: ((PresentableError) -> Void)? = nil,
        coordinationPickPhoto: (((URL?) -> Void) -> Void)? = nil
    ) -> FormSectionViewModel {
        return sut.buildViewModel(
            photoSectionMetadata: FormMetadata.PhotoSection(maxCount: maxPhotos, title: "title"),
            coordination: {
                switch $0 {
                case .didFailToUploadPhoto(let error): coordinationOnUploadFailed?(error)
                case .pickPhoto(let picker): coordinationPickPhoto?(picker)
                }
            }
        )
    }
}

private extension FormSectionViewModel {
    private struct InvalidSubsectionType: Error { }

    func photoPickerViewModel(
        updates: FormPhotoPickerViewUpdates,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> FormPhotoPickerViewModel {
        switch subSectionViewModel {
        case .photos(let builder):
            return builder(updates)
        default:
            XCTFail("Invalid subsection view model type", file: file, line: line)
            throw InvalidSubsectionType()
        }
    }
}

private extension FormPhotoPickerViewModel {
    private struct InvalidPhotoCellType: Error { }

    func addNewPhotoCell(
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> () -> Void {
        let maybeClosure: (() -> Void)? = cells.compactMap {
            switch $0 {
            case .addNew(let closure): return closure
            default: return nil
            }
        }.first
        guard let closure = maybeClosure else {
            XCTFail("No cell with addNew type", file: file, line: line)
            throw InvalidPhotoCellType()
        }
        return closure
    }
}

private extension Array where Iterator.Element == FormPhotoPickerViewModel.CellViewModel {
    var photoCellsCount: Int {
        return filter {
            switch $0 {
            case .photo: return true
            default: return false
            }
        }.count
    }
    
    var hasAddNewTypeCell: Bool {
        return contains(where: {
            switch $0 {
            case .addNew: return true
            default: return false
            }
        })
    }
}
