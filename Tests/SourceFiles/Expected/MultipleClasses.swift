// MARK: - Mocks generated from file: ../../Tests/SourceFiles/MultipleClasses.swift
//
//  MultipleClasses.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

import UIKit

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
    
    override var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            manager.setter("readWriteProperty", value: newValue, original: observed != nil ? { self.observed?.readWriteProperty = $0 } : nil)
        }
    }

    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(manager: manager, name: "readWriteProperty")
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
        
        var readWriteProperty: Cuckoo.VerifyProperty<Int> {
            return Cuckoo.VerifyProperty(manager: manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

class MockB: B, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_B
    typealias Verification = __VerificationProxy_B
    let manager = Cuckoo.MockManager()

    private var observed: B?

    required override init() {
    }

    required init(spyOn victim: B) {
        observed = victim
    }
    
    override var readOnlyProperty: Int {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> Int in o.readOnlyProperty } })
        }
    }

    struct __StubbingProxy_B: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<Int> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: manager, name: "readOnlyProperty")
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
        
        var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<Int> {
            return Cuckoo.VerifyReadOnlyProperty(manager: manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}