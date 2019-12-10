import Foundation
import UIKit

protocol PhotoPickerTableViewCellUpdates: AnyObject {
    func update(with model: PhotoPickerCellViewModel)
}

struct PhotoPickerCellViewModel {
    let url: URL
}

final class PhotoPickerTableViewCell: UITableViewCell, PhotoPickerTableViewCellUpdates {
    private lazy var squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.widthAnchor
            .constraint(equalTo: imageView.heightAnchor)
            .isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        contentView.addSubview(squareImageView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            squareImageView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 18),
            squareImageView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            squareImageView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -8),
            squareImageView.trailingAnchor
                .constraint(equalTo: titleLabel.leadingAnchor, constant: -36),
            titleLabel.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: PhotoPickerCellViewModel) {
        titleLabel.text = model.url.absoluteString
    }
}
