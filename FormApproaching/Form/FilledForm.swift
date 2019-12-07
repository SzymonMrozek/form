import Foundation

struct FilledForm: Codable {
    var photos: [URL]
}

enum FormEdition: Equatable {
    case addPhoto(URL)
}
