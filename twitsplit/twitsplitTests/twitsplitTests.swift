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
        let expected = ["1/6 I can\'t believe Tweeter now supports chunking",
                        "2/6 my messages, so I don\'t have to do it myself.I",
                        "3/6 just want to send a message to my friends with",
                        "4/6 over 50 characters length, without to post it",
                        "5/6 twice or more than one time. This app helps me",
                        "6/6 a lot, it is very useful, thank developers :)"]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output, expected, "The end part of messgae wasn't added to new component")
    }
    
    func testOrdinaryCase() {
        let input = "Linearity is the property of a mathematical relationship or function which means that it can be graphically represented as a straight line. Examples are the relationship of voltage and current across a resistor, or the mass and weight of an object."
        
        let expected = ["1/6 Linearity is the property of a mathematical",
                        "2/6 relationship or function which means that it",
                        "3/6 can be graphically represented as a straight",
                        "4/6 line. Examples are the relationship of voltage",
                        "5/6 and current across a resistor, or the mass and",
                        "6/6 weight of an object."]
        let output = Utils.split(input, limit: limit)
        XCTAssertEqual(output, expected, "The end part of messgae wasn't added to new component")
    }
    
    func testToughCase() {
        let input = "Apart from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. To check word count, simply place your cursor into the text box above and start typing. You'll see the number of characters and words increase or decrease as you type, delete, and edit them. You can also copy and paste text from another program over into the online editor above. The Auto-Save feature will make sure you won't lose any changes while editing, even if you leave the site and come back later. Tip: Bookmark this page now."
        
        let expected = ["1/15 Apart from counting words and characters, our",
                        "2/15 online editor can help you to improve word",
                        "3/15 choice and writing style, and, optionally,",
                        "4/15 help you to detect grammar mistakes and",
                        "5/15 plagiarism. To check word count, simply place",
                        "6/15 your cursor into the text box above and start",
                        "7/15 typing. You\'ll see the number of characters",
                        "8/15 and words increase or decrease as you type,",
                        "9/15 delete, and edit them. You can also copy and",
                        "10/15 paste text from another program over into",
                        "11/15 the online editor above. The Auto-Save",
                        "12/15 feature will make sure you won\'t lose any",
                        "13/15 changes while editing, even if you leave the",
                        "14/15 site and come back later. Tip: Bookmark this",
                        "15/15 page now."]
        
        // When
        let output = Utils.split(input, limit: limit)
        
        // Then
        XCTAssertEqual(output, expected, "The end part of messgae wasn't added to new component")
    }
    
}
