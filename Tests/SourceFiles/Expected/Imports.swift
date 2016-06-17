// MARK: - Mocks generated from file: ../../Tests/SourceFiles/Imports.swift
//
//  Imports.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

import UIKit
import XCTest
import Foundation

class MockA: A, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<__StubbingProxy_A, __VerificationProxy_A> = Cuckoo.MockManager()

    private var observed: A?

    required override init() {
    }

    required init(spyOn victim: A) {
        observed = victim
    }

    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
    }

    struct __VerificationProxy_A: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
    }
}

class MockB: B, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<__StubbingProxy_B, __VerificationProxy_B> = Cuckoo.MockManager()

    private var observed: B?

    required init() {
    }

    required init(spyOn victim: B) {
        observed = victim
    }
    
    var text: String {
        get {
            return manager.getter("text", original: observed.map { o in return { () -> String in o.text } })()
        }
    }

    struct __StubbingProxy_B: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        var text: ToBeStubbedReadOnlyProperty<String> {
            return handler.stubReadOnlyProperty("text")
        }
    }

    struct __VerificationProxy_B: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        var text: VerifyReadOnlyProperty<String> {
            return handler.verifyReadOnlyProperty("text")
        }
    }
}