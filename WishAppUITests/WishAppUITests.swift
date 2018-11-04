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
        let wishListNavBarNavigationBar = XCUIApplication().navigationBars["wish_list_nav_bar"]
        wishListNavBarNavigationBar.buttons["search_button"].tap()
        wishListNavBarNavigationBar.searchFields["search_textfield"].tap()
        self.app.typeText("Doodle Jump\n")
        let excp = expectation(description: "Perform Search")
        iTunesSearchAPI.shared.loadApps(for: "Doodle Jump", limit: 50) { (_ result: AppSearchResult?) in
            excp.fulfill()
        }
        wait(for: [excp], timeout: 30.0)
        snapshot("Search")
    }
}
