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
    let manager: Cuckoo.MockManager<__StubbingProxy_TestedClass, __VerificationProxy_TestedClass> = Cuckoo.MockManager()

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
            manager.setter("readWriteProperty", value: newValue, original: { self.observed?.readWriteProperty = $0 })
        }
    }
    
    override var optionalProperty: Int? {
        get {
            return manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            manager.setter("optionalProperty", value: newValue, original: { self.observed?.optionalProperty = $0 })
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
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: ToBeStubbedReadOnlyProperty<String> {
            return handler.stubReadOnlyProperty("readOnlyProperty")
        }
        
        var readWriteProperty: ToBeStubbedProperty<Int> {
            return handler.stubProperty("readWriteProperty")
        }
        
        var optionalProperty: ToBeStubbedProperty<Int?> {
            return handler.stubProperty("optionalProperty")
        }
        
        @warn_unused_result
        func noParameter() -> Cuckoo.ToBeStubbedFunction<(), Void> {
            return handler.stub("noParameter()")
        }
        
        @warn_unused_result
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.ToBeStubbedFunction<(String),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.stub("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withReturn() -> Cuckoo.ToBeStubbedFunction<(),  String> {
            return handler.stub("withReturn()-> String")
        }
        
        @warn_unused_result
        func withThrows() -> Cuckoo.ToBeStubbedThrowingFunction<(), Void> {
            return handler.stubThrowing("withThrows()throws")
        }
        
        @warn_unused_result
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosure(_:String -> Int)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosureReturningInt(_:String -> Int)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.ToBeStubbedFunction<(String, b: Int, c: Float), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.stub("withMultipleParameters(_:String, b:Int, c:Float)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: String -> Void), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withNoescape(_:String, closure:String -> Void)", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: (String -> Void)?), Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withOptionalClosure(_:String, closure:(String -> Void)?)", parameterMatchers: matchers)
        }
    }

    struct __VerificationProxy_TestedClass: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: VerifyReadOnlyProperty<String> {
            return handler.verifyReadOnlyProperty("readOnlyProperty")
        }
        
        var readWriteProperty: VerifyProperty<Int> {
            return handler.verifyProperty("readWriteProperty")
        }
        
        var optionalProperty: VerifyProperty<Int?> {
            return handler.verifyProperty("optionalProperty")
        }
        
        func noParameter() -> Cuckoo.__DoNotUse<Void>{
            return handler.verify("noParameter()")
        }
        
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.verify("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        func withReturn() -> Cuckoo.__DoNotUse< String>{
            return handler.verify("withReturn()-> String")
        }
        
        func withThrows() -> Cuckoo.__DoNotUse<Void>{
            return handler.verify("withThrows()throws")
        }
        
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosure(_:String -> Int)", parameterMatchers: matchers)
        }
        
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosureReturningInt(_:String -> Int)-> Int", parameterMatchers: matchers)
        }
        
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.verify("withMultipleParameters(_:String, b:Int, c:Float)", parameterMatchers: matchers)
        }
        
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withNoescape(_:String, closure:String -> Void)", parameterMatchers: matchers)
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse<Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withOptionalClosure(_:String, closure:(String -> Void)?)", parameterMatchers: matchers)
        }
    }
}

// MARK: - Mocks generated from file: ../../Tests/SourceFiles/TestedProtocol.swift
//
//  TestedProtocol.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Cuckoo

class MockTestedProtocol: TestedProtocol, Cuckoo.Mock {
    let manager: Cuckoo.MockManager<__StubbingProxy_TestedProtocol, __VerificationProxy_TestedProtocol> = Cuckoo.MockManager()

    private var observed: TestedProtocol?

    required init() {
    }

    required init(spyOn victim: TestedProtocol) {
        observed = victim
    }
    
    var readOnlyProperty: String {
        get {
            return manager.getter("readOnlyProperty", original: observed.map { o in return { () -> String in o.readOnlyProperty } })
        }
    }
    
    var readWriteProperty: Int {
        get {
            return manager.getter("readWriteProperty", original: observed.map { o in return { () -> Int in o.readWriteProperty } })
        }
        set {
            manager.setter("readWriteProperty", value: newValue, original: { self.observed?.readWriteProperty = $0 })
        }
    }
    
    var optionalProperty: Int? {
        get {
            return manager.getter("optionalProperty", original: observed.map { o in return { () -> Int? in o.optionalProperty } })
        }
        set {
            manager.setter("optionalProperty", value: newValue, original: { self.observed?.optionalProperty = $0 })
        }
    }
    
    func noParameter() -> Void {
        return manager.call("noParameter() -> Void", parameters: Void(), original: observed.map { o in return { () -> Void in o.noParameter() } })
    }
    
    func countCharacters(test: String)-> Int {
        return manager.call("countCharacters(_:String)-> Int", parameters: (test), original: observed.map { o in return { (test: String)-> Int in o.countCharacters(test) } })
    }
    
    func withReturn()-> String {
        return manager.call("withReturn()-> String", parameters: Void(), original: observed.map { o in return { ()-> String in o.withReturn() } })
    }
    
    func withThrows() throws -> Void {
        return try manager.callThrows("withThrows() throws -> Void", parameters: Void(), original: observed.map { o in return { () throws -> Void in try o.withThrows() } })
    }
    
    func withClosure(closure: String -> Int) -> Void {
        return manager.call("withClosure(_:String -> Int) -> Void", parameters: (closure), original: observed.map { o in return { (closure: String -> Int) -> Void in o.withClosure(closure) } })
    }
    
    func withClosureReturningInt(closure: String -> Int)-> Int {
        return manager.call("withClosureReturningInt(_:String -> Int)-> Int", parameters: (closure), original: observed.map { o in return { (closure: String -> Int)-> Int in o.withClosureReturningInt(closure) } })
    }
    
    func withMultipleParameters(a: String, b: Int, c: Float) -> Void {
        return manager.call("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameters: (a, b: b, c: c), original: observed.map { o in return { (a: String, b: Int, c: Float) -> Void in o.withMultipleParameters(a, b: b, c: c) } })
    }
    
    func withNoescape(a: String, @noescape closure: String -> Void) -> Void {
        return manager.call("withNoescape(_:String, closure:String -> Void) -> Void", parameters: (a, closure: Cuckoo.markerFunction()), original: observed.map { o in return { (a: String, @noescape closure: String -> Void) -> Void in o.withNoescape(a, closure: closure) } })
    }
    
    func withOptionalClosure(a: String, closure: (String -> Void)?) -> Void {
        return manager.call("withOptionalClosure(_:String, closure:(String -> Void)?) -> Void", parameters: (a, closure: closure), original: observed.map { o in return { (a: String, closure: (String -> Void)?) -> Void in o.withOptionalClosure(a, closure: closure) } })
    }

    struct __StubbingProxy_TestedProtocol: Cuckoo.StubbingProxy {
        let handler: Cuckoo.StubbingHandler
    
        init(handler: Cuckoo.StubbingHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: ToBeStubbedReadOnlyProperty<String> {
            return handler.stubReadOnlyProperty("readOnlyProperty")
        }
        
        var readWriteProperty: ToBeStubbedProperty<Int> {
            return handler.stubProperty("readWriteProperty")
        }
        
        var optionalProperty: ToBeStubbedProperty<Int?> {
            return handler.stubProperty("optionalProperty")
        }
        
        @warn_unused_result
        func noParameter() -> Cuckoo.ToBeStubbedFunction<(),  Void> {
            return handler.stub("noParameter() -> Void")
        }
        
        @warn_unused_result
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.ToBeStubbedFunction<(String),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.stub("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withReturn() -> Cuckoo.ToBeStubbedFunction<(),  String> {
            return handler.stub("withReturn()-> String")
        }
        
        @warn_unused_result
        func withThrows() -> Cuckoo.ToBeStubbedThrowingFunction<(),  Void> {
            return handler.stubThrowing("withThrows() throws -> Void")
        }
        
        @warn_unused_result
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosure(_:String -> Int) -> Void", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.ToBeStubbedFunction<(String -> Int),  Int> {
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.stub("withClosureReturningInt(_:String -> Int)-> Int", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.ToBeStubbedFunction<(String, b: Int, c: Float),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.stub("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: String -> Void),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withNoescape(_:String, closure:String -> Void) -> Void", parameterMatchers: matchers)
        }
        
        @warn_unused_result
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.ToBeStubbedFunction<(String, closure: (String -> Void)?),  Void> {
            let matchers: [Cuckoo.AnyMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.stub("withOptionalClosure(_:String, closure:(String -> Void)?) -> Void", parameterMatchers: matchers)
        }
    }

    struct __VerificationProxy_TestedProtocol: Cuckoo.VerificationProxy {
        let handler: Cuckoo.VerificationHandler
    
        init(handler: Cuckoo.VerificationHandler) {
            self.handler = handler
        }
        
        var readOnlyProperty: VerifyReadOnlyProperty<String> {
            return handler.verifyReadOnlyProperty("readOnlyProperty")
        }
        
        var readWriteProperty: VerifyProperty<Int> {
            return handler.verifyProperty("readWriteProperty")
        }
        
        var optionalProperty: VerifyProperty<Int?> {
            return handler.verifyProperty("optionalProperty")
        }
        
        func noParameter() -> Cuckoo.__DoNotUse< Void>{
            return handler.verify("noParameter() -> Void")
        }
        
        func countCharacters<M1: Cuckoo.Matchable where M1.MatchedType == (String)>(test: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String)>] = [parameterMatcher(test.matcher) { $0 }]
            return handler.verify("countCharacters(_:String)-> Int", parameterMatchers: matchers)
        }
        
        func withReturn() -> Cuckoo.__DoNotUse< String>{
            return handler.verify("withReturn()-> String")
        }
        
        func withThrows() -> Cuckoo.__DoNotUse< Void>{
            return handler.verify("withThrows() throws -> Void")
        }
        
        func withClosure<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosure(_:String -> Int) -> Void", parameterMatchers: matchers)
        }
        
        func withClosureReturningInt<M1: Cuckoo.Matchable where M1.MatchedType == (String -> Int)>(closure: M1) -> Cuckoo.__DoNotUse< Int>{
            let matchers: [Cuckoo.AnyMatcher<(String -> Int)>] = [parameterMatcher(closure.matcher) { $0 }]
            return handler.verify("withClosureReturningInt(_:String -> Int)-> Int", parameterMatchers: matchers)
        }
        
        func withMultipleParameters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (Int), M3.MatchedType == (Float)>(a: M1, b: M2, c: M3) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, b: Int, c: Float)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(b.matcher) { $0.b }, parameterMatcher(c.matcher) { $0.c }]
            return handler.verify("withMultipleParameters(_:String, b:Int, c:Float) -> Void", parameterMatchers: matchers)
        }
        
        func withNoescape<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == (String -> Void)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: String -> Void)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withNoescape(_:String, closure:String -> Void) -> Void", parameterMatchers: matchers)
        }
        
        func withOptionalClosure<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable where M1.MatchedType == (String), M2.MatchedType == ((String -> Void)?)>(a: M1, closure: M2) -> Cuckoo.__DoNotUse< Void>{
            let matchers: [Cuckoo.AnyMatcher<(String, closure: (String -> Void)?)>] = [parameterMatcher(a.matcher) { $0.0 }, parameterMatcher(closure.matcher) { $0.closure }]
            return handler.verify("withOptionalClosure(_:String, closure:(String -> Void)?) -> Void", parameterMatchers: matchers)
        }
    }
}