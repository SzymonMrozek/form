import Foundation
import UIKit

// sourcery: AutoMockable
protocol FormPhotoPickerViewUpdates: AnyObject {
    func updateWithCells(cells: [FormPhotoPickerViewModel.CellViewModel]) 
}

struct FormPhotoPickerViewModel {
    enum CellViewModel {
        case photo(URL)
        case addNew(() -> Void)
    }
    
    let cells: [CellViewModel]
}

final class FormPhotoPickerView: UIView, FormPhotoPickerViewUpdates {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(builder: (FormPhotoPickerViewUpdates) -> FormPhotoPickerViewModel) {
        let viewModel = builder(self)
        rebuild(forCells: viewModel.cells)
    }
    
    func updateWithCells(cells: [FormPhotoPickerViewModel.CellViewModel]) {
        rebuild(forCells: cells)
    }
    
    private func rebuild(forCells cells: [FormPhotoPickerViewModel.CellViewModel]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        cells.map { viewModel in
            switch viewModel {
            case .photo(let url):
                let redView = UIView()
                redView.backgroundColor = .red
                redView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    redView.heightAnchor.constraint(equalToConstant: 60),
                    redView.widthAnchor.constraint(equalToConstant: 60)
                ])
                return redView
            case .addNew(let action):
                let addButton = AddNewPhotoCell(onTap: action)
                addButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    addButton.heightAnchor.constraint(equalToConstant: 60),
                    addButton.widthAnchor.constraint(equalToConstant: 60)
                ])
                return addButton as UIView
            }
        }
        .forEach(stackView.addArrangedSubview)
    }
}

private final class AddNewPhotoCell: UIView {
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let onTap: () -> Void
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapButton(_ button: UIButton) {
        onTap()
    }
}
