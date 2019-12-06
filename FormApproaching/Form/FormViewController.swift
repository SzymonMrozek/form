import Foundation
import UIKit

final class FormViewController: UIViewController {
    private let viewModelBuilder: FormViewModelBuilder

    init(viewModelBuilder: FormViewModelBuilder) {
        self.viewModelBuilder = viewModelBuilder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let formView = FormView(frame: view.frame)
        self.view = formView
    
        formView.build(builder: viewModelBuilder.buildViewModel)
    }
}
