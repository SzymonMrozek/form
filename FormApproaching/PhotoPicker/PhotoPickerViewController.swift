import Foundation
import UIKit

final class PhotoPickerViewController: UIViewController {
    private let viewModelBuilder: PhotoPickerTableViewModelBuilder

    init(viewModelBuilder: PhotoPickerTableViewModelBuilder) {
        self.viewModelBuilder = viewModelBuilder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let tableView = PhotoPickerTableView()
        self.view = tableView
    
        tableView.build(builder: viewModelBuilder.buildViewModel)
    }
}
