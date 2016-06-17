//
//  Imports.swift
//  Cuckoo
//
//  Created by Tadeas Kriz on 18/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import UIKit; import XCTest

// Class A
class A {
    let text = "import x"
}

protocol B {
	var text: String { get }
}

import Foundation

extension B {
	var text: String {
		return "import y"
	}
}