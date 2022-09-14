//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import XCTest
@testable import CodeChallenge

final class CodeChallengeTests: XCTestCase {
    var viewModel: FeedViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        viewModel = FeedViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testDataString() {
        let answer = viewModel?.getDate(WithString: "2009-12-21T00:00:00Z", format: "dd MMM, yyyy")
        XCTAssertEqual(answer, "21 Dec, 2009")
    }


    

}
