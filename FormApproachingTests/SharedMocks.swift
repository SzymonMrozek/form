import Foundation
@testable import FormApproaching

class F1Mock<A> {
    var receivedArgument: A?
    var called: Bool = false
    var callCount: Int = 0
    var f: ((A) -> Void)?
    
    init(_ f: ((A) -> Void)? = nil) {
        self.f = f
    }
    
    func closure(a: A) -> Void {
        receivedArgument = a
        called = true
        callCount += 1
        f?(a)
    }
}
