import XCTest
@testable import FormApproaching

class PhotoPickerTableViewModelBuilderTests: XCTestCase {
    private var sut: PhotoPickerTableViewModelBuilder!
    private var photoAlbumProvidingMock: PhotoAlbumProvidingMock!
    private var tableViewUpdatesMock: PhotoPickerTableViewUpdatesMock!
    
    private let mockUrl = URL(string: "mockUrl.com")!
    
    override func setUp() {
        super.setUp()
        tableViewUpdatesMock = PhotoPickerTableViewUpdatesMock()
        photoAlbumProvidingMock = PhotoAlbumProvidingMock()
    }
    
    override func tearDown() {
        tableViewUpdatesMock = nil
        photoAlbumProvidingMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_buildViewModel_ShouldReturnNoCells_WhenNoURLsProvided() {
        // Arrange
        mock(urls: nil)
        
        // Act
        buildViewModel()
        
        // Assert
        XCTAssertEqual(tableViewUpdatesMock.updateWithReceivedCells?.count, 0)
    }
    
    func test_buildViewModel_ShouldReturn3Cells_When3URLsProvided() {
        // Arrange
        mock(urls: [mockUrl, mockUrl, mockUrl])
        
        // Act
        buildViewModel()
        
        // Assert
        XCTAssertEqual(tableViewUpdatesMock.updateWithReceivedCells?.count, 3)
    }
    
    func test_tableViewUpdates_ShouldCallUpdateOnce_WhenModelIsBuilt() {
        // Arrange
        mock(urls: [mockUrl])
        
        // Act
        buildViewModel()
        
        // Assert
        XCTAssertEqual(tableViewUpdatesMock.updateWithCallsCount, 1)
    }
    
    func test_tableViewUpdates_ShouldCallUpdateTwice_WhenModelIsBuiltAndUpdated() {
        // Arrange
        mock(urls: [mockUrl])
        
        // Act
        buildViewModel()
        tableViewUpdatesMock.update(with: [])
        
        // Assert
        XCTAssertEqual(tableViewUpdatesMock.updateWithCallsCount, 2)
    }
    
    func test_photoSelection_ShouldReturnURL_WhenURLIsSelected() {
        // Arrange
        let testUrl = URL(string: "testUrl.com")!
        var selectedUrl: URL?
        mock(
            urls: [mockUrl, testUrl],
            coordinationPhotoSelected: { selectedUrl = $0 }
         )
        
        // Act
        let viewModel = buildViewModel()
        viewModel.didSelectPhoto(testUrl)
        
        // Assert
        XCTAssertEqual(selectedUrl, testUrl)
    }
    
    func test_deinit_ShouldCancelFetchingPhotos_WhenDeinitialized() {
        // Arrange
        mock(urls: nil)
        let cancellableMock = CancellableMock()
        photoAlbumProvidingMock.getPhotosCompletionClosure = { _ in cancellableMock }
        
        // Act
        buildViewModel()
        sut = nil
        
        // Assert
        XCTAssertEqual(cancellableMock.cancelCallsCount, 1)
    }

    @discardableResult private func buildViewModel() -> PhotoPickerTableViewModel {
        return sut.buildViewModel(updates: tableViewUpdatesMock)
    }
    
    private func mock(
        urls: [URL]?,
        coordinationPhotoSelected: ((URL) -> Void)? = nil
    ) {
        let dataResult: Result<PhotosResponse, URLError> = urls == nil ?
            .failure(URLError(.cancelled)) :
            .success(PhotosResponse(photosURL: urls!))
        photoAlbumProvidingMock.getPhotosCompletionClosure = { completion -> Cancellable in
            completion(dataResult)
            return CancellableMock()
        }
        let dependencyMock = HasPhotoAlbumProvidingMock()
        dependencyMock.underlyingPhotoAlbumProviding = photoAlbumProvidingMock
        
        sut = PhotoPickerTableViewModelBuilder(dependencies: dependencyMock, coordination: {
            switch $0 {
            case .selected(let url): coordinationPhotoSelected?(url)
            }
        })
    }
}
