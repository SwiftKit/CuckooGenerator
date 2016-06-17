import Cuckoo

import Foundation

class MockTestedEmptyClass: TestedEmptyClass, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<__StubbingProxy_TestedEmptyClass, __VerificationProxy_TestedEmptyClass> = Cuckoo.MockManager()

    private var observed: TestedEmptyClass?

    required override init() {
    }

    required init(spyOn victim: TestedEmptyClass) {
        observed = victim
    }

    struct __StubbingProxy_TestedEmptyClass: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
    }

    struct __VerificationProxy_TestedEmptyClass: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
    }
}