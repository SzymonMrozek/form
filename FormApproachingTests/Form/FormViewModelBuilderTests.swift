import XCTest
@testable import FormApproaching

class FormViewModelBuilderTests: XCTestCase {
    private var sut: FormViewModelBuilder!
    private var formPhotoPickerViewModelBuilderMock: FormPhotoPickerViewModelBuildingMock!
    private var formModelControllerMock: FormModelControllingMock!
    private var viewUpdatesMock: FormViewUpdatesMock!
    private var coordinationMock: F1Mock<FormViewCoordination>!
    
    private let urlMock = URL(string: "https://mocked.com")!
    
    override func setUp() {
        super.setUp()
        formPhotoPickerViewModelBuilderMock = FormPhotoPickerViewModelBuildingMock()
        formModelControllerMock = FormModelControllingMock()
        viewUpdatesMock = FormViewUpdatesMock()
        coordinationMock = F1Mock()
        
        sut = FormViewModelBuilder(
            formModelController: formModelControllerMock,
            formPhotoPickerViewModelBuilder: formPhotoPickerViewModelBuilderMock,
            coordination: coordinationMock.closure
        )
    }
    
    override func tearDown() {
        formPhotoPickerViewModelBuilderMock = nil
        coordinationMock = nil
        formModelControllerMock = nil
        viewUpdatesMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_buildViewModel_ShouldReturnSections_WhenFormFetchedSuccessfuly() {
        // Arrange
        mock(
            fetchedFormMetadata: .success(FormMetadata(
                    photoSection: FormMetadata.PhotoSection(maxCount: 5, title: "title")
                )
            )
        )
        
        // Act
        let initialViewModel = sut.buildViewModel(updates: viewUpdatesMock)
        
        
        // Assert
        XCTAssertEqual(initialViewModel.sections.count, 0)
        XCTAssertEqual(viewUpdatesMock.updateWithReceivedSections?.count, 1)
    }
    
    func test_buildViewModel_ShouldReturnNoSections_WhenFormFetchFailed() {
        // Arrange
        mock(fetchedFormMetadata: .failure(.unknown))
        
        // Act
        _ = sut.buildViewModel(updates: viewUpdatesMock)
        
        // Assert
        XCTAssertEqual(viewUpdatesMock.updateWithReceivedSections?.count, 0)
    }
    
    func test_deinit_ShouldCancelFormFetch_WhenDeinitialized() {
        // Arrange
        let cancellableMock = CancellableMock()
        formModelControllerMock.getFormMetadataCompletionReturnValue = cancellableMock
        
        // Act
        _ = sut.buildViewModel(updates: viewUpdatesMock)
        formModelControllerMock.getFormMetadataCompletionReceivedCompletion = nil
        sut = nil
        
        // Assert
        XCTAssertEqual(cancellableMock.cancelCallsCount, 1)
    }
    
    private func mock(
        fetchedFormMetadata: Result<FormMetadata, GetFormError>,
        photoSection: FormSectionViewModel = FormSectionViewModel(title: "photo", selection: .none, subSectionViewModel: .none)
    ) {
        formModelControllerMock.getFormMetadataCompletionClosure = {
            $0(fetchedFormMetadata)
            return CancellableMock()
        }
        formPhotoPickerViewModelBuilderMock.buildViewModelPhotoSectionMetadataCoordinationReturnValue =  photoSection
    }
}
