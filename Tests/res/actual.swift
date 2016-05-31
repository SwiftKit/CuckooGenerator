// MARK: - Mocks generated from file: /Users/filip/Documents/tmspark/CuckooGenerator/Tests/res/source/TestedClass.swift at 2016-05-31 08:45:03 +0000

//
//  TestedClass.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 09/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//


import Cuckoo
@testable import CuckooGenerator

internal class MockTestedClass: TestedClass, Cuckoo.Mock {
    internal let manager: Cuckoo.MockManager<__StubbingProxy_TestedClass, __VerificationProxy_TestedClass> = Cuckoo.MockManager()

    private var observed: TestedClass?

    internal required override init() {
        observed = nil
    }

    internal required init(spyOn victim: TestedClass) {
        observed = victim
    }
    internal override var readOnlyProperty: String {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })()
        }
    }
    internal override var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })()
        }
        set(newValue) {
            manager.setter("readWriteProperty", value: newValue, original: { self.observed?.readWriteProperty = $0 })(newValue)
        }
    }
    
    internal override func noParameter() {
        return manager.call("noParameter()", original: observed.map { o in return { () in o.noParameter() } })()
    }
    
    internal override func countCharacters(test: String)-> Int {
        return manager.call("countCharacters(_:String)-> Int", parameters: (test), original: observed.map { o in return { (test: String)-> Int in o.countCharacters(test) } })(test)
    }
    
    internal override func withReturn()-> String {
        return manager.call("withReturn()-> String", original: observed.map { o in return { ()-> String in o.withReturn() } })()
    }
    
    internal override func withThrows()throws {
        return try manager.callThrows("withThrows()throws", original: observed.map { o in return { ()throws in try o.withThrows() } })()
    }
    
    internal override func withClosure(closure: String -> Int) {
        return manager.call("withClosure(_:String -> Int)", parameters: (closure), original: observed.map { o in return { (closure: String -> Int) in o.withClosure(closure) } })(closure)
    }
    
    internal override func withMultipleParameters(a: String, b: Int, c: Float) {
        return manager.call("withMultipleParameters(_:String, b:Int, c:Float)", parameters: (a, b: b, c: c), original: observed.map { o in return { (a: String, b: Int, c: Float) in o.withMultipleParameters(a, b: b, c: c) } })(a, b: b, c: c)
    }
    
    internal override func withNoescape(a: String, @noescape closure: String -> Void) {
        return manager.call("withNoescape(_:String, closure:String -> Void)", parameters: (a, closure: Cuckoo.markerFunction()), original: observed.map { o in return { (a: String, @noescape closure: String -> Void) in o.withNoescape(a, closure: closure) } })(a, closure: Cuckoo.markerFunction())
    }

    internal struct __StubbingProxy_TestedClass: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
        internal init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        var readOnlyProperty: ToBeStubbedReadOnlyProperty<String> {
            return handler.stubReadOnlyProperty("readOnlyProperty")
        }
        var readWriteProperty: ToBeStubbedProperty<Int> {
            return handler.stubProperty("readWriteProperty")
        }
        
        @warn_unused_result
        internal func noParameter() -> Cuckoo.ToBeStubbedFunction<(), Void> {
            return handler.stub("noParameter()")
        }
        
        @warn_unused_result
        internal func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.ToBeStubbedFunction<(String),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.stub("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withReturn() -> Cuckoo.ToBeStubbedFunction<(),  String> {
            return handler.stub("withReturn()-> String")
        }
        
        @warn_unused_result
        internal func withThrows() -> Cuckoo.ToBeStubbedThrowingFunction<(), Void> {
            return handler.stubThrowing("withThrows()throws")
        }
        
        @warn_unused_result
        internal func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosure(_:String -> Int)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.ToBeStubbedFunction<(String, b: Int, c: Float), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.stub("withMultipleParameters(_:String, b:Int, c:Float)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: String -> Void), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withNoescape(_:String, closure:String -> Void)", parameterMatchers: matchers)
        }
    }

    internal struct __VerificationProxy_TestedClass: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        internal init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        var readOnlyProperty: VerifyReadOnlyProperty<String> {
            return handler.verifyReadOnlyProperty("readOnlyProperty")
        }
        var readWriteProperty: VerifyProperty<Int> {
            return handler.verifyProperty("readWriteProperty")
        }
        
        internal func noParameter() -> Cuckoo.__DoNotUse<Void>{
            
            return handler.verify("noParameter()")
        }
        
        internal func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.verify("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        internal func withReturn() -> Cuckoo.__DoNotUse< String>{
            
            return handler.verify("withReturn()-> String")
        }
        
        internal func withThrows() -> Cuckoo.__DoNotUse<Void>{
            
            return handler.verify("withThrows()throws")
        }
        
        internal func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosure(_:String -> Int)", parameterMatchers: matchers)
        }
        
        internal func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.verify("withMultipleParameters(_:String, b:Int, c:Float)", parameterMatchers: matchers)
        }
        
        internal func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withNoescape(_:String, closure:String -> Void)", parameterMatchers: matchers)
        }
    
    }
}

// MARK: - Mocks generated from file: /Users/filip/Documents/tmspark/CuckooGenerator/Tests/res/source/TestedProtocol.swift at 2016-05-31 08:45:03 +0000

//
//  TestedProtocol.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//


import Cuckoo
@testable import CuckooGenerator

internal class MockTestedProtocol: TestedProtocol, Cuckoo.Mock {
    internal let manager: Cuckoo.MockManager<__StubbingProxy_TestedProtocol, __VerificationProxy_TestedProtocol> = Cuckoo.MockManager()

    private var observed: TestedProtocol?

    internal required init() {
        observed = nil
    }

    internal required init(spyOn victim: TestedProtocol) {
        observed = victim
    }
    internal var readOnlyProperty: String {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })()
        }
    }
    internal var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })()
        }
        set(newValue) {
            manager.setter("readWriteProperty", value: newValue, original: { self.observed?.readWriteProperty = $0 })(newValue)
        }
    }
    
    internal func noParameter() -> Void {
        return manager.call("noParameter() -> Void", original: observed.map { o in return { () -> Void in o.noParameter() } })()
    }
    
    internal func countCharacters(test: String)-> Int {
        return manager.call("countCharacters(_:String)-> Int", parameters: (test), original: observed.map { o in return { (test: String)-> Int in o.countCharacters(test) } })(test)
    }
    
    internal func withReturn()-> String {
        return manager.call("withReturn()-> String", original: observed.map { o in return { ()-> String in o.withReturn() } })()
    }
    
    internal func withThrows() throws -> Void {
        return try manager.callThrows("withThrows() throws -> Void", original: observed.map { o in return { () throws -> Void in try o.withThrows() } })()
    }
    
    internal func withClosure(closure: String -> Int) -> Void {
        return manager.call("withClosure(_:String -> Int) -> Void", parameters: (closure), original: observed.map { o in return { (closure: String -> Int) -> Void in o.withClosure(closure) } })(closure)
    }
    
    internal func withMultipleParameters(a: String, b: Int, c: Float) -> Void {
        return manager.call("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameters: (a, b: b, c: c), original: observed.map { o in return { (a: String, b: Int, c: Float) -> Void in o.withMultipleParameters(a, b: b, c: c) } })(a, b: b, c: c)
    }
    
    internal func withNoescape(a: String, @noescape closure: String -> Void) -> Void {
        return manager.call("withNoescape(_:String, closure:String -> Void) -> Void", parameters: (a, closure: Cuckoo.markerFunction()), original: observed.map { o in return { (a: String, @noescape closure: String -> Void) -> Void in o.withNoescape(a, closure: closure) } })(a, closure: Cuckoo.markerFunction())
    }

    internal struct __StubbingProxy_TestedProtocol: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
        internal init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        var readOnlyProperty: ToBeStubbedReadOnlyProperty<String> {
            return handler.stubReadOnlyProperty("readOnlyProperty")
        }
        var readWriteProperty: ToBeStubbedProperty<Int> {
            return handler.stubProperty("readWriteProperty")
        }
        
        @warn_unused_result
        internal func noParameter() -> Cuckoo.ToBeStubbedFunction<(),  Void> {
            return handler.stub("noParameter() -> Void")
        }
        
        @warn_unused_result
        internal func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.ToBeStubbedFunction<(String),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.stub("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withReturn() -> Cuckoo.ToBeStubbedFunction<(),  String> {
            return handler.stub("withReturn()-> String")
        }
        
        @warn_unused_result
        internal func withThrows() -> Cuckoo.ToBeStubbedThrowingFunction<(),  Void> {
            return handler.stubThrowing("withThrows() throws -> Void")
        }
        
        @warn_unused_result
        internal func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosure(_:String -> Int) -> Void", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.ToBeStubbedFunction<(String, b: Int, c: Float),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.stub("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        internal func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: String -> Void),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withNoescape(_:String, closure:String -> Void) -> Void", parameterMatchers: matchers)
        }
    }

    internal struct __VerificationProxy_TestedProtocol: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        internal init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        var readOnlyProperty: VerifyReadOnlyProperty<String> {
            return handler.verifyReadOnlyProperty("readOnlyProperty")
        }
        var readWriteProperty: VerifyProperty<Int> {
            return handler.verifyProperty("readWriteProperty")
        }
        
        internal func noParameter() -> Cuckoo.__DoNotUse< Void>{
            
            return handler.verify("noParameter() -> Void")
        }
        
        internal func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.verify("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        internal func withReturn() -> Cuckoo.__DoNotUse< String>{
            
            return handler.verify("withReturn()-> String")
        }
        
        internal func withThrows() -> Cuckoo.__DoNotUse< Void>{
            
            return handler.verify("withThrows() throws -> Void")
        }
        
        internal func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosure(_:String -> Int) -> Void", parameterMatchers: matchers)
        }
        
        internal func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.verify("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameterMatchers: matchers)
        }
        
        internal func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withNoescape(_:String, closure:String -> Void) -> Void", parameterMatchers: matchers)
        }
    
    }
}