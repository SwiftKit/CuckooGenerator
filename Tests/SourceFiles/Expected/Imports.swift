// MARK: - Mocks generated from file: ../../Tests/SourceFiles/Imports.swift
//
//  Imports.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

import a
import b
import c
import d
import e
import f
import g
import h
import i

class MockA: A, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_A
    typealias Verification = __VerificationProxy_A
    let manager = Cuckoo.MockManager()

    private var observed: A?

    required override init() {
    }

    required init(spyOn victim: A) {
        observed = victim
    }

    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
    }

    struct __VerificationProxy_A: Cuckoo.VerificationProxy {
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

class MockB: B, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_B
    typealias Verification = __VerificationProxy_B
    let manager = Cuckoo.MockManager()

    private var observed: B?

    required init() {
    }

    required init(spyOn victim: B) {
        observed = victim
    }
    
    var text: String {
        get {
            return manager.getter("text", original: observed.map { o in return { () -> String in o.text } })
        }
    }

    struct __StubbingProxy_B: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
        
        var text: Cuckoo.ToBeStubbedReadOnlyProperty<String> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: manager, name: "text")
        }
    }

    struct __VerificationProxy_B: Cuckoo.VerificationProxy {
        let manager: Cuckoo.MockManager
        let callMatcher: Cuckoo.CallMatcher
        let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var text: Cuckoo.VerifyReadOnlyProperty<String> {
            return Cuckoo.VerifyReadOnlyProperty(manager: manager, name: "text", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}