// MARK: - Mocks generated from file: ../../Tests/SourceFiles/ClassWithAttributes.swift
/* Multi
   line
   comment */

import Cuckoo

public class MockClassWithAttributes: ClassWithAttributes, Cuckoo.Mock {
    public typealias Stubbing = __StubbingProxy_ClassWithAttributes
    public typealias Verification = __VerificationProxy_ClassWithAttributes
    public let manager = Cuckoo.MockManager()

    private var observed: ClassWithAttributes?

    public required override init() {
    }

    public required init(spyOn victim: ClassWithAttributes) {
        observed = victim
    }

    public struct __StubbingProxy_ClassWithAttributes: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }

    public struct __VerificationProxy_ClassWithAttributes: Cuckoo.VerificationProxy {
        let manager: Cuckoo.MockManager
        let callMatcher: Cuckoo.CallMatcher
        let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}