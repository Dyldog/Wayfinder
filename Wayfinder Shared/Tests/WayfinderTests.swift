import XCTest

class WayfinderTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        continueAfterFailure = false
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
        snapshot("0_Home_Screen")
    }
}
