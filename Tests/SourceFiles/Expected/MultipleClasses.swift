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
    let manager: Cuckoo.MockManager<__StubbingProxy_A, __VerificationProxy_A> = Cuckoo.MockManager()

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
            manager.setter("readWriteProperty", value: newValue, original: { self.observed?.readWriteProperty = $0 })
        }
    }

    struct __StubbingProxy_A: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(handler: handler, name: "readWriteProperty")
        }
    }

    struct __VerificationProxy_A: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        var readWriteProperty: VerifyProperty<Int> {
            return handler.verifyProperty("readWriteProperty")
        }
    }
}

class MockB: B, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<__StubbingProxy_B, __VerificationProxy_B> = Cuckoo.MockManager()

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
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<Int> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(handler: handler, name: "readOnlyProperty")
        }
    }

    struct __VerificationProxy_B: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: VerifyReadOnlyProperty<Int> {
            return handler.verifyReadOnlyProperty("readOnlyProperty")
        }
    }
}