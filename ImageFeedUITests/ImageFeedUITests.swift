import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("bezrukovandrejj@yandex.ru")
        webView.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("6752718B!")
        webView.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
//        sleep(5)
//        let tablesQuery = app.tables
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        cell.swipeUp()
//
//        sleep(5)
//
//        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)
//        sleep(3)
//
//        cellToLike.buttons["likeButton"].tap()
//        sleep(3)
//
//        cellToLike.buttons["likeButton"].tap()
//
//        sleep(5)
//
//        cellToLike.tap()
//
//        sleep(5)
//
//        let image = app.scrollViews.images.element(boundBy: 0)
//        image.pinch(withScale: 3, velocity: 1)
//        image.pinch(withScale: 0.5, velocity: -1)
//
//        let navBackButtonWhiteButton = app.buttons["navBackButton"]
//        navBackButtonWhiteButton.tap()
        sleep(5)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        sleep(3)

        tablesQuery.element.swipeUp()
        tablesQuery.element.swipeDown()

        let firstCell = tablesQuery.cells.element(boundBy: 0)
        let likeButton = firstCell.buttons["likeButton"]
        likeButton.tap()
        sleep(3)

        likeButton.tap()
        sleep(3)

        firstCell.tap()
        sleep(5)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)

        image.pinch(withScale: 0.5, velocity: -1)
        sleep(3)

        app.buttons["navBackButton"].tap()
        sleep(3)
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Andrey Bezrukov"].exists)
        XCTAssertTrue(app.staticTexts["@bezrukov1987"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
