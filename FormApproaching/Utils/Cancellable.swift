import Foundation

// sourcery: AutoMockable
protocol Cancellable {
    func cancel()
}

final class CancellableStore {
    fileprivate var cancellables = [Cancellable]()
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

extension Cancellable {
    func store(in collection: inout [Cancellable]) {
        collection.append(self)
    }
    
    func store(in cancellableStore: CancellableStore) {
        store(in: &cancellableStore.cancellables)
    }
}
