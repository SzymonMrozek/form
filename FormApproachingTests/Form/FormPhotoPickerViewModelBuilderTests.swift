import XCTest
@testable import FormApproaching

class FormApproachingTests: XCTestCase {
    private var sut: FormPhotoPickerViewModelBuilder!
    private var formModelControllerMock: FormModelControllingMock!
    private var formEditorMock: FormEditingMock!
    private var viewUpdatesMock: FormPhotoPickerViewUpdatesMock!
    
    private let urlMock = URL(string: "https://mocked.com")!
    
    override func setUp() {
        super.setUp()
        formModelControllerMock = FormModelControllingMock()
        formEditorMock = FormEditingMock()
        viewUpdatesMock = FormPhotoPickerViewUpdatesMock()
        
        sut = FormPhotoPickerViewModelBuilder(
            formModelController: formModelControllerMock,
            formEditor: formEditorMock
        )
    }
    
    override func tearDown() {
        formModelControllerMock.uploadPhotoUrlCompletionReceivedArguments = nil
        formModelControllerMock = nil
        formEditorMock = nil
        viewUpdatesMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_buildViewModel_ShouldReturnNoPhotosAndAddCell_WhenNoPhotosInCurrentFormVersion() throws {
        // Arrange
        formEditorMock.currentVersion = FormEdition(photos: [])
        
        // Act
        let viewModel = try buildViewModel().photoPickerViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewModel.cells.count, 1)
        XCTAssertEqual(viewModel.cells.photoCellsCount, 0)
    }
    
    func test_buildViewModel_ShouldReturn1PhotoAndAddCell_When1PhotoInCurrentFormVersion() throws {
        // Arrange
        formEditorMock.currentVersion = FormEdition(photos: [urlMock])
        
        // Act
        let viewModel = try buildViewModel().photoPickerViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewModel.cells.count, 2)
        XCTAssertEqual(viewModel.cells.photoCellsCount, 1)
    }
    
    func test_buildViewModel_ShouldReturn3PhotoAndNoAddCell_When3PhotoInCurrentFormVersionAndMaximumCountIs3Photos() throws {
        // Arrange
        formEditorMock.currentVersion = FormEdition(photos: [urlMock, urlMock, urlMock])
        
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
        formEditorMock.currentVersion = FormEdition(photos: [])
        formModelControllerMock.uploadPhotoUrlCompletionClosure = { [urlMock] (_, completion) in
            completion(.success(urlMock))
            return CancellableMock()
        }
        
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
        XCTAssertEqual(formEditorMock.currentVersion.photos.count, 1)
    }
    
    func test_buildViewModel_ShouldNotCommitNewPhotoAndPresentError_WhenNewPhotoAddedViaCoordinationAndUploadFailed() throws {
        // Arrange
        formEditorMock.currentVersion = FormEdition(photos: [])
        formModelControllerMock.uploadPhotoUrlCompletionClosure = { (_, completion) in
            completion(.failure(.unknown))
            return CancellableMock()
        }
        
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
        XCTAssertEqual(formEditorMock.currentVersion.photos.count, 0)
    }
    
    func test_buildViewModel_ShouldDoNothing_WhenNewPhotoAdditionCancelled() throws {
        // Arrange
        formEditorMock.currentVersion = FormEdition(photos: [])
        
        // Act
        try buildViewModel(
            coordinationOnUploadFailed: { _ in XCTFail("Invalid coordination triggered") },
            coordinationPickPhoto: { $0(nil) }
        )
        .photoPickerViewModel(updates: viewUpdatesMock)
        .addNewPhotoCell()()

        // Assert
        XCTAssertEqual(viewUpdatesMock.updateWithCellsCellsCallsCount, 0)
        XCTAssertEqual(formEditorMock.currentVersion.photos.count, 0)
    }
    
    func test_deinit_ShouldCancelPhotoUpload_WhenDeinitialized() throws {
        // Arrange
        let cancellableMock = CancellableMock()
        formEditorMock.currentVersion = FormEdition(photos: [])
        formModelControllerMock.uploadPhotoUrlCompletionReturnValue = cancellableMock
        
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
    
    private func buildViewModel(
        maxPhotos: Int = 5,
        coordinationOnUploadFailed: ((PresentableError) -> Void)? = nil,
        coordinationPickPhoto: (((URL?) -> Void) -> Void)? = nil
    ) -> FormSectionViewModel {
        return sut.buildViewModel(
            photoSectionMeta: FormData.PhotoSectionMeta(maxCount: maxPhotos, title: "title"),
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
