import Foundation

struct FormEdition: Codable {
    var photos: [URL]
}

protocol FormEditing: AnyObject {
    var currentVersion: FormEdition { get }
    
    func commit<T>(_ keyPath: WritableKeyPath<FormEdition, T>, value: T)
}

protocol HasFormEditing {
    var formEditing: FormEditing { get }
}

final class FormEditor: FormEditing {
    private(set) var currentVersion: FormEdition = FormEdition(
        photos: []
    )
    
    func commit<T>(_ keyPath: WritableKeyPath<FormEdition, T>, value: T) {
        currentVersion[keyPath: keyPath] = value
        saveOnDisk()
    }

    private func saveOnDisk() {
        // ....
    }
}
