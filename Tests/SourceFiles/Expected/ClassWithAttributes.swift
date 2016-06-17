// MARK: - Mocks generated from file: ../../Tests/SourceFiles/ClassWithAttributes.swift
/* Multi
   line
   comment */

import Cuckoo

public class MockClassWithAttributes: ClassWithAttributes, Cuckoo.Mock {
    public let manager: Cuckoo.MockManager<__StubbingProxy_ClassWithAttributes, __VerificationProxy_ClassWithAttributes> = Cuckoo.MockManager()

    private var observed: ClassWithAttributes?

    public required override init() {
    }

    public required init(spyOn victim: ClassWithAttributes) {
        observed = victim
    }

    public struct __StubbingProxy_ClassWithAttributes: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        public init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
    }

    public struct __VerificationProxy_ClassWithAttributes: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        public init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
    }
}