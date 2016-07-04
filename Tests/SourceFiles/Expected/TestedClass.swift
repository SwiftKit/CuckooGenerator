// MARK: - Mocks generated from file: ../../Tests/SourceFiles/TestedClass.swift
//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockTestedClass: TestedClass, Cuckoo.Mock {
    typealias Stubbing = __StubbingProxy_TestedClass
    typealias Verification = __VerificationProxy_TestedClass
    let manager = Cuckoo.MockManager()

    private var observed: TestedClass?

    required override init() {
    }

    required init(spyOn victim: TestedClass) {
        observed = victim
    }
    
    override var readOnlyProperty: String {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })
        }
    }
    
    override var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            manager.setter("readWriteProperty", value: newValue, original: observed != nil ? { self.observed?.readWriteProperty = $0 } : nil)
        }
    }
    
    override var optionalProperty: Int? {
        get {
            return manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            manager.setter("optionalProperty", value: newValue, original: observed != nil ? { self.observed?.optionalProperty = $0 } : nil)
        }
    }
    
    override func noParameter() {
        return manager.call("noParameter()", parameters: Void(), original: observed.map { o in return { () in o.noParameter() } })
    }
    
    override func countCharacters(test: String)-> Int {
        return manager.call("countCharacters(_:String)-> Int", parameters: (test), original: observed.map { o in return { (test: String)-> Int in o.countCharacters(test) } })
    }
    
    override func withReturn()-> String {
        return manager.call("withReturn()-> String", parameters: Void(), original: observed.map { o in return { ()-> String in o.withReturn() } })
    }
    
    override func withThrows()throws {
        return try manager.callThrows("withThrows()throws", parameters: Void(), original: observed.map { o in return { ()throws in try o.withThrows() } })
    }
    
    override func withClosure(closure: String -> Int) {
        return manager.call("withClosure(_:String -> Int)", parameters: (closure), original: observed.map { o in return { (closure: String -> Int) in o.withClosure(closure) } })
    }
    
    override func withClosureReturningInt(closure: String -> Int)-> Int {
        return manager.call("withClosureReturningInt(_:String -> Int)-> Int", parameters: (closure), original: observed.map { o in return { (closure: String -> Int)-> Int in o.withClosureReturningInt(closure) } })
    }
    
    override func withMultipleParameters(a: String, b: Int, c: Float) {
        return manager.call("withMultipleParameters(_:String, b:Int, c:Float)", parameters: (a, b: b, c: c), original: observed.map { o in return { (a: String, b: Int, c: Float) in o.withMultipleParameters(a, b: b, c: c) } })
    }
    
    override func withNoescape(a: String, @noescape closure: String -> Void) {
        return manager.call("withNoescape(_:String, closure:String -> Void)", parameters: (a, closure: Cuckoo.markerFunction()), original: observed.map { o in return { (a: String, @noescape closure: String -> Void) in o.withNoescape(a, closure: closure) } })
    }
    
    override func withOptionalClosure(a: String, closure: (String -> Void)?) {
        return manager.call("withOptionalClosure(_:String, closure:(String -> Void)?)", parameters: (a, closure: closure), original: observed.map { o in return { (a: String, closure: (String -> Void)?) in o.withOptionalClosure(a, closure: closure) } })
    }

    struct __StubbingProxy_TestedClass: Cuckoo.StubbingProxy {
        let manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.manager = manager
        }
        
        var readOnlyProperty: Cuckoo.ToBeStubbedReadOnlyProperty<String> {
            return Cuckoo.ToBeStubbedReadOnlyProperty(manager: manager, name: "readOnlyProperty")
        }
        
        var readWriteProperty: Cuckoo.ToBeStubbedProperty<Int> {
            return Cuckoo.ToBeStubbedProperty(manager: manager, name: "readWriteProperty")
        }
        
        var optionalProperty: Cuckoo.ToBeStubbedProperty<Int?> {
            return Cuckoo.ToBeStubbedProperty(manager: manager, name: "optionalProperty")
        }
        
        @warn_unused_result
        func noParameter() -> Cuckoo.StubNoReturnFunction<()> {
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("noParameter()", parameterMatchers: []))
        }
        
        @warn_unused_result
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.StubFunction<(String), Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return Cuckoo.StubFunction(stub: manager.createStub("countCharacters(_:String)-> Int", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withReturn() -> Cuckoo.StubFunction<(), String> {
            return Cuckoo.StubFunction(stub: manager.createStub("withReturn()-> String", parameterMatchers: []))
        }
        
        @warn_unused_result
        func withThrows() -> Cuckoo.StubNoReturnThrowingFunction<()> {
            return Cuckoo.StubNoReturnThrowingFunction(stub: manager.createStub("withThrows()throws", parameterMatchers: []))
        }
        
        @warn_unused_result
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.StubNoReturnFunction<(String -> Int)> {
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withClosure(_:String -> Int)", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.StubFunction<(String -> Int), Int> {
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return Cuckoo.StubFunction(stub: manager.createStub("withClosureReturningInt(_:String -> Int)-> Int", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.StubNoReturnFunction<(String, b: Int, c: Float)> {
            let matchers: [Cuckoo.ParameterMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withMultipleParameters(_:String, b:Int, c:Float)", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, closure: String -> Void)> {
            let matchers: [Cuckoo.ParameterMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withNoescape(_:String, closure:String -> Void)", parameterMatchers: matchers))
        }
        
        @warn_unused_result
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.StubNoReturnFunction<(String, closure: (String -> Void)?)> {
            let matchers: [Cuckoo.ParameterMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return Cuckoo.StubNoReturnFunction(stub: manager.createStub("withOptionalClosure(_:String, closure:(String -> Void)?)", parameterMatchers: matchers))
        }
    }

    struct __VerificationProxy_TestedClass: Cuckoo.VerificationProxy {
        let manager: Cuckoo.MockManager
        let callMatcher: Cuckoo.CallMatcher
        let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var readOnlyProperty: Cuckoo.VerifyReadOnlyProperty<String> {
            return Cuckoo.VerifyReadOnlyProperty(manager: manager, name: "readOnlyProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var readWriteProperty: Cuckoo.VerifyProperty<Int> {
            return Cuckoo.VerifyProperty(manager: manager, name: "readWriteProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var optionalProperty: Cuckoo.VerifyProperty<Int?> {
            return Cuckoo.VerifyProperty(manager: manager, name: "optionalProperty", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        func noParameter() -> Cuckoo.__DoNotUse<Void>{
            return manager.verify("noParameter()", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.__DoNotUse<Int>{
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return manager.verify("countCharacters(_:String)-> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withReturn() -> Cuckoo.__DoNotUse<String>{
            return manager.verify("withReturn()-> String", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func withThrows() -> Cuckoo.__DoNotUse<Void>{
            return manager.verify("withThrows()throws", callMatcher: callMatcher, parameterMatchers: [] as [Cuckoo.ParameterMatcher<Void>], sourceLocation: sourceLocation)
        }
        
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return manager.verify("withClosure(_:String -> Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse<Int>{
            let matchers: [Cuckoo.ParameterMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return manager.verify("withClosureReturningInt(_:String -> Int)-> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.ParameterMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return manager.verify("withMultipleParameters(_:String, b:Int, c:Float)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.ParameterMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return manager.verify("withNoescape(_:String, closure:String -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.ParameterMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return manager.verify("withOptionalClosure(_:String, closure:(String -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
    }
}