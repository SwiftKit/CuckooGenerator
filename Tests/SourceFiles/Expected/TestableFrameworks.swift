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
@testable import A_b
@testable import A_c
@testable import A_d

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