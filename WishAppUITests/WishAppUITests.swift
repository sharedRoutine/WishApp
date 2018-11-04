//
//  WishAppUITests.swift
//  WishAppUITests
//
//  Created by Janosch Hübner on 29.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import XCTest

#if DEBUG
import SimulatorStatusMagic
#endif

class WishAppUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        #if DEBUG
            SDStatusBarManager.sharedInstance().enableOverrides()
        #endif
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app = XCUIApplication()
        self.app.launchArguments = ["WISHAPP_TESTING"]
        setupSnapshot(self.app)
        self.app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func waitForElementToAppear(_ element: XCUIElement) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let exp = expectation(for: predicate, evaluatedWith: element, handler: nil)
        let result = XCTWaiter().wait(for: [exp], timeout: 10)
        return result == .completed
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainScreenshots() {
        snapshot("Main")
        let tablesQuery = self.app.tables.cells
        tablesQuery.element(boundBy: 3).swipeRight()
        sleep(2)
        snapshot("Check")
        self.app.tap()
        tablesQuery.element(boundBy: 3).swipeLeft()
        sleep(2)
        snapshot("Delete")
        self.app.tap()
    }

    func testSearchScreenshots() {
        self.app.navigationBars["wish_list_nav_bar"].buttons["search_button"].tap()
        sleep(2)
        let searchField = self.app.tables["search_table"].searchFields["Search"]
        searchField.tap()
        self.app.typeText("Doodle Jump")
        self.app.buttons["Search"].tap()
        assert(self.waitForElementToAppear(self.app.tables["search_table"].cells.staticTexts["Doodle Jump"]))
        sleep(2)
        snapshot("Search")
    }
}
