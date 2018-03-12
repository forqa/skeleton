//
//  SkeletonUITests.swift
//  SkeletonUITests
//
//  Created by a.alterpesotskiy on 12/03/2018.
//  Copyright © 2018 forqa. All rights reserved.
//

import XCTest

let app = XCUIApplication(bundleIdentifier: ProcessInfo.processInfo.environment["bundle_id"]!)

class SkeletonUITests: XCTestCase {
    
    func testMe() {
        app.activate()
        print("start_grep_tag")
        print(app.debugDescription)
        print("end_grep_tag")
    }
    
}
