//
//  recrutamento_iosUITests.swift
//  recrutamento-iosUITests
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import XCTest

class recrutamento_iosUITests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        let image = app.collectionViews.cells.otherElements.containingType(.StaticText, identifier:"The X-Files").childrenMatchingType(.Image).element
        image.tap()
        
        let button = app.navigationBars["The X-Files"].buttons[" "]
        button.tap()
        XCUIDevice.sharedDevice().orientation = .LandscapeRight
        image.tap()
        button.tap()
        XCUIDevice.sharedDevice().orientation = .Portrait
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
