//
//  RainbowSnakeUITests.swift
//  RainbowSnakeUITests
//
//  Created by theo on 06/05/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import XCTest

class RainbowSnakeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("01game")
        waitForExpectations(timeout: 5, handler: nil)
        snapshot("02retry")
    }

}
