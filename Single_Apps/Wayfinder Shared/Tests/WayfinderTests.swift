import XCTest

class WayfinderTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        continueAfterFailure = false
        app.launchArguments = ["MOCK_LOCATION"]
        app.launch()
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert in
            let allow = alert.buttons["Allow While Using App"]
            if allow.exists {
                allow.tap()
                return true
            }
            
            return false
        }
        
        app.swipeUp()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func testScreenshot() {
        waitToNotExist(app.staticTexts["Searching..."], timeout: 5.0)
        snapshot("0_Home_Screen")
    }
}

extension XCTestCase {
    func waitToNotExist(_ element: XCUIElement, timeout: Double) {
        let doesNotExistPredicate = NSPredicate(format: "exists == FALSE")
        self.expectation(for: doesNotExistPredicate, evaluatedWith: element, handler: nil)
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
}
