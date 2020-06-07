//
//  Login-Tests.swift
//  PoetTests
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

@testable import Poet
import XCTest

class Login_Tests: XCTestCase {
    typealias Action = Login.Evaluator.Action
    typealias Element = Login.Evaluator.Element
    
    var screen: Login.Screen?
    var evaluator: Login.Evaluator?
    var translator: Login.Translator?
    
    // override func setUpWithError() throws { // <-- new xcode
    override func setUp() { // <-- old xcode
        // Put setup code here. This method is called before the invocation of each test method in the class.
        screen = Login.Screen()
        evaluator = screen?.evaluator
        translator = screen?.translator
    }

    // override func tearDownWithError() throws { // <-- new xcode
    override func tearDown() { // <-- old xcode
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginSuccessShowsAlert() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: true)
        evaluator?.showLoginStep()
        evaluator?.evaluate(Action.signIn)
        XCTAssert(translator?.alert.alertConfiguration?.title == "Login Succeeded!", "Alert title should say 'Login Succeeded!' Actual: \(String(describing: translator?.alert.alertConfiguration?.title))")
    }
    
    func testLoginFailureShowsAlert() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: false)
        evaluator?.showLoginStep()
        evaluator?.evaluate(Action.signIn)
        XCTAssert(translator?.alert.alertConfiguration?.title == "Login Failed", "Alert title should say 'Login Failed' Actual: \(String(describing: translator?.alert.alertConfiguration?.title))")
    }
    
    func testUsernameCharacterCountValidation() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: true)
        evaluator?.showLoginStep()
        
        // Invalid: hey
        evaluator?.textFieldDidChange(text: "hey", elementName: Element.usernameTextField)
        XCTAssert(translator?.usernameValidation.isValid.bool == false, "Username should be invalid. Actual: \(String(describing: translator?.usernameValidation.isValid.bool))")
        
        // Valid: hello
        evaluator?.textFieldDidChange(text: "hello", elementName: Element.usernameTextField)
        XCTAssert(translator?.usernameValidation.isValid.bool == true, "Username should be valid.  Actual: \(String(describing: translator?.usernameValidation.isValid.bool))")
    }

    func testUsernameBadCharacterValidation() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: true)
        evaluator?.showLoginStep()
        
        // Valid: hello
        evaluator?.textFieldDidChange(text: "hello", elementName: Element.usernameTextField)
        XCTAssert(translator?.usernameValidation.isValid.bool == true, "Username should be valid. Actual: \(String(describing: translator?.usernameValidation.isValid.bool))")
        
        // Invalid: hello,\=
        evaluator?.textFieldDidChange(text: "hello,\\=", elementName: Element.usernameTextField)
        XCTAssert(translator?.usernameValidation.isValid.bool == false, "Username should be invalid.  Actual: \(String(describing: translator?.usernameValidation.isValid.bool))")
    }
    
    func testPasswordCharacterCountValidation() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: true)
        evaluator?.showLoginStep()
        
        // Invalid: 123
        evaluator?.textFieldDidChange(text: "123", elementName: Element.passwordTextField)
        XCTAssert(translator?.passwordValidation.isValid.bool == false, "Password should be invalid. Actual: \(String(describing: translator?.passwordValidation.isValid.bool))")
        
        // Valid: 123456
        evaluator?.textFieldDidChange(text: "123456", elementName: Element.passwordTextField)
        XCTAssert(translator?.passwordValidation.isValid.bool == true, "Password should be valid.  Actual: \(String(describing: translator?.passwordValidation.isValid.bool))")
    }

    func testPasswordBadCharacterValidation() throws {
        evaluator?.performer = LoginMockPerformer(shouldSucceed: true)
        evaluator?.showLoginStep()
        
        // Valid: 123456
        evaluator?.textFieldDidChange(text: "123456", elementName: Element.passwordTextField)
        XCTAssert(translator?.passwordValidation.isValid.bool == true, "Password should be valid. Actual: \(String(describing: translator?.passwordValidation.isValid.bool))")
        
        // Invalid: 123456@.
        evaluator?.textFieldDidChange(text: "123456@.", elementName: Element.passwordTextField)
        XCTAssert(translator?.passwordValidation.isValid.bool == false, "Password should be invalid.  Actual: \(String(describing: translator?.passwordValidation.isValid.bool))")
    }
}
