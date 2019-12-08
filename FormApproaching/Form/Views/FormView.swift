import Foundation
import UIKit

// sourcery: AutoMockable
protocol FormViewUpdates: AnyObject {
    func update(with sections: [FormSectionViewModel])
}

struct FormViewModel {
    let sections: [FormSectionViewModel]
}

final class FormView: UIView, FormViewUpdates {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(builder: (FormViewUpdates) -> FormViewModel) {
        let viewModel = builder(self)
        reloadStackView(forSections: viewModel.sections)
    }
    
    func update(with sections: [FormSectionViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadStackView(forSections: sections)
        }
    }
    
    private func reloadStackView(forSections sections: [FormSectionViewModel]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        sections.map(FormSectionView.init)
            .forEach(stackView.addArrangedSubview)
    }
}
