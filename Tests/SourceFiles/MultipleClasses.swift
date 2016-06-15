//
//  MultipleClasses.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import UIKit

class A {
    lazy var readWriteProperty: Int = 0
}

class B {
    var readOnlyProperty: Int {
        return 0
    }
}