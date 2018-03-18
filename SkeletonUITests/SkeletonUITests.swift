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
        sleep(1)
        print("start_grep_tag")
        print(app.debugDescription)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        add(attachment)
        print("end_grep_tag")
    }
    
}
