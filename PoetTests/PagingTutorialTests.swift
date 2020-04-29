//
//  PagingTutorialTests.swift
//  PoetTests
//
//  Created by Stephen E Cotner on 4/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import XCTest
@testable import Poet

class PagingTutorialTests: XCTestCase {
    
    var screen = PagingTutorial.Screen()
    lazy var evaluator = screen.evaluator!
    lazy var translator = evaluator.translator

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatPagesLoadAfterViewAppears() {
        
        // GIVEN we have a freshly created screen, evaluator, and translator.
        
        let pagesHaveNotLoaded = translator.pageBody.array.isEmpty
        
        XCTAssert(pagesHaveNotLoaded,
          """
          There should be no pages yet.
          Actual: \(translator.pageBody.array)
          """
        )
        
        // WHEN the page appears
        
        evaluator.viewDidAppear()
        
        let pagesHaveLoaded = translator.pageBody.array.isEmpty == false
        
        // THEN the pages should load
        
        XCTAssert(pagesHaveLoaded,
          """
          There should be pages now.
          Actual: \(translator.pageBody.array)
          """
        )
    }

}
