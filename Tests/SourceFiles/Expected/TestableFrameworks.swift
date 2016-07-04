// MARK: - Mocks generated from file: ../../Tests/SourceFiles/TestedEmptyClass.swift
//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo
@testable import Cuckoo

import Foundation

class MockTestedEmptyClass: TestedEmptyClass, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_TestedEmptyClass
    typealias Verification = __VerificationProxy_TestedEmptyClass
    let manager = Cuckoo.MockManager()

    private var observed: TestedEmptyClass?

    required override init() {
    }

    required init(spyOn victim: TestedEmptyClass) {
        observed = victim
    }

    struct __StubbingProxy_TestedEmptyClass: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }

    struct __VerificationProxy_TestedEmptyClass: Cuckoo.VerificationProxy {
        let manager: Cuckoo.MockManager
        let callMatcher: Cuckoo.CallMatcher
        let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    }
}