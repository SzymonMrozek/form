import Foundation
import UIKit

// sourcery: AutoMockable
protocol PhotoPickerTableViewUpdates: AnyObject {
    func update(with cells: [PhotoPickerCellViewModel])
}

struct PhotoPickerTableViewModel {
    let cells: [PhotoPickerCellViewModel]
    let didSelectPhoto: (URL) -> Void
}

final class PhotoPickerTableView: UITableView, PhotoPickerTableViewUpdates {
    private var cells: [PhotoPickerCellViewModel]
    private var didSelectPhoto: ((URL) -> Void)?
    
    init() {
        cells = []
        super.init(
            frame: .zero,
            style: .plain
        )
        delegate = self
        dataSource = self
        rowHeight = 64.0
        register(
            PhotoPickerTableViewCell.self,
            forCellReuseIdentifier: "PhotoPickerTableViewCell"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(builder: (PhotoPickerTableViewUpdates) -> PhotoPickerTableViewModel) {
        let viewModel = builder(self)
        didSelectPhoto = viewModel.didSelectPhoto
        cells = viewModel.cells
        reloadData()
    }
    
    func update(with cells: [PhotoPickerCellViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.cells = cells
            self?.reloadData()
        }
    }
}

extension PhotoPickerTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PhotoPickerTableViewCell",
            for: indexPath
        ) as! PhotoPickerTableViewCell
        cell.update(with: cells[indexPath.row])
        return cell
    }
}

extension PhotoPickerTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectPhoto?(cells[indexPath.row].url)
    }
}
