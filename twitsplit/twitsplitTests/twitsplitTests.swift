//
//  twitsplitTests.swift
//  twitsplitTests
//
//  Created by Leon Yuu on 1/12/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import XCTest
@testable import TwitSplit

class twitsplitTests: XCTestCase {
    
    let limit = 50
    let error = ["The message contains a span of non-whitespace characters longer than 50 characters"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCaseExampleAssigment() {
        
        // Give
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output.count, 2, "Result: 2 components")
        XCTAssertEqual(output, expected, "Expected: Same the expectation from the Assignment")
    }
    
    func testCaseMessageShorterThanLimit() {
        
        // Give
        let input = "Test a short message has length shorter than 50"
        let expected = ["Test a short message has length shorter than 50"]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output.count, 1, "Result: 1 components")
        XCTAssertEqual(output, expected, "Expected: Short Message should be same the original")
    }
    
    func testCaseMessagewithRedundantSpan() {
        
        // Give
        let input = "Test  a    long    message    has    length    greater    than    50"
        let expected = ["Test a long message has length greater than 50"]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output.count, 1, "Result: 1 components")
        XCTAssertEqual(output, expected, "Expected: Message will be remove redudant span and splitted if needed")
    }
    
    func testCaseMessagewithRedundantSpanandLineBreak() {
        
        // Give
        let input = "Test  a    long    message    has    \n\n\n   length    greater \n\n\n    than    50"
        let expected = ["Test a long message has length greater than 50"]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output.count, 1, "Result: 1 components")
        XCTAssertEqual(output, expected, "Expected: Message will be remove redudant span and line break, then splitted if needed")
    }
    
    func testCaseMessageHasNonSpanPartLongerThanLimit() {
        
        // Give
        let input = "TestAChunkofCharactersThatHasLengthOver50toShowAnError"
        let expected = error
        
        // When
        let output = Utils.split(input, limit: limit)
        
        //Then
        XCTAssertEqual(output, expected)
    }
    
    func testCaseMessageHasNonSpanPartLongerThanLimitwithSpan() {
        
        // Give
        let input = "TestAChunkofCharactersThatHasLengthOver50toShowAnError TestAChunkofCharactersThatHasLengthOver50toShowAnError TestAChunkofCharactersThatHasLengthOver50toShowAnError TestAChunkofCharactersThatHasLengthOver50toShowAnError"
        let expected = error
        
        // When
        let output = Utils.split(input, limit: limit)
        
        //Then
        XCTAssertEqual(output, expected)
    }
    
    
    func testCaseComponentWithNewOneCase() {
        
        // Give
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I just want to send a message to my friends with over 50 characters length, without to post it twice or more than one time. This app helps me a lot, it is very useful, thank developers :)"
        let expected = ["1/7 I can\'t believe Tweeter now supports chunking",
                        "2/7 my messages, so I don\'t have to do it",
                        "3/7 myself.I just want to send a message to my",
                        "4/7 friends with over 50 characters length,",
                        "5/7 without to post it twice or more than one",
                        "6/7 time. This app helps me a lot, it is very",
                        "7/7 useful, thank developers :)"]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output, expected, "The end part of messgae wasn't added to new component")
    }
    
}
