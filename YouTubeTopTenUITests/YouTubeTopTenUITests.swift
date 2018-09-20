//
//  YouTubeTopTenUITests.swift
//  YouTubeTopTenUITests
//
//  Created by Bryan Mazariegos on 9/17/18.
//  Copyright © 2018 Bryan Mazariegos. All rights reserved.
//

import XCTest

class YouTubeTopTenUITests: XCTestCase {
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMusic() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.searchFields["Search"].tap()
        app.typeText("Kanye West")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 1.5)
        app.tables.cells.firstMatch.tap()
        app.webViews/*@START_MENU_TOKEN@*/.buttons["Play"]/*[[".otherElements[\"YouTube video player\"]",".otherElements[\"YouTube Video Player\"].buttons[\"Play\"]",".buttons[\"Play\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 20)
        app.tap()
        app.buttons["Play/Pause"].tap()
        app.buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
    }
    
    func testMovies() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.searchFields["Search"].tap()
        app.typeText("Transformers")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 2)
        app.buttons["Movie"].tap()
        Thread.sleep(forTimeInterval: 2)
        app.tables.cells.firstMatch.tap()
        app.webViews/*@START_MENU_TOKEN@*/.buttons["Play"]/*[[".otherElements[\"YouTube video player\"]",".otherElements[\"YouTube Video Player\"].buttons[\"Play\"]",".buttons[\"Play\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 20)
        app.tap()
        app.buttons["Play/Pause"].tap()
        app.buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
    }
    
    func testShows() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.searchFields["Search"].tap()
        app.typeText("Teen Titans")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 2)
        app.buttons["Show"].tap()
        Thread.sleep(forTimeInterval: 3)
        app.tables.cells.firstMatch.tap()
        app.webViews/*@START_MENU_TOKEN@*/.buttons["Play"]/*[[".otherElements[\"YouTube video player\"]",".otherElements[\"YouTube Video Player\"].buttons[\"Play\"]",".buttons[\"Play\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 20)
        app.tap()
        app.buttons["Play/Pause"].tap()
        app.buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
    }
    
    func testNoResults() {
        app.searchFields["Search"].tap()
        app.typeText("Youth & Consequences")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        Thread.sleep(forTimeInterval: 2)
        app.buttons["Show"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        app.buttons["OK"].tap()
    }
    
}
