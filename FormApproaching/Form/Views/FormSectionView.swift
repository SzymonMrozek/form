import Foundation
import UIKit

struct FormSectionViewModel {
    enum SubSectionViewModel {
        case subtitle(String)
        case photos((FormPhotoPickerViewUpdates) -> FormPhotoPickerViewModel)
        case none
    }
    
    let title: String
    let selection: Selection
    let subSectionViewModel: SubSectionViewModel
    
    enum Selection {
        case none
        case disclosure(() -> Void)
    }
}

final class FormSectionView: UIView {
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: FormSectionViewModel) {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleLabel.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        titleLabel.text = viewModel.title
        
        switch viewModel.selection {
        case .none: break
        case .disclosure(let action): fatalError("Not implemented")
        }
        
        switch viewModel.subSectionViewModel {
        case .none:
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])
        case .subtitle(let subtitle):
            addSubview(subtitleLabel)
            NSLayoutConstraint.activate([
                subtitleLabel.leadingAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
                subtitleLabel.topAnchor
                    .constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                subtitleLabel.trailingAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
                subtitleLabel.bottomAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])
            subtitleLabel.text = subtitle
        case .photos(let viewModelBuilder):
            let photoPickerView = FormPhotoPickerView()
            photoPickerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(photoPickerView)
            NSLayoutConstraint.activate([
                photoPickerView.leadingAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
                photoPickerView.topAnchor
                    .constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                photoPickerView.trailingAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
                photoPickerView.bottomAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])
            photoPickerView.bind(builder: viewModelBuilder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

