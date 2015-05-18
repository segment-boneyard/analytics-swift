//
//  AnalyticsTests.swift
//  AnalyticsTests
//
//  Created by Prateek Srivastava on 2015-05-14.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Cocoa
import XCTest
import Analytics

class AnalyticsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func testExample() {
    var client = Client(writeKey: "Z2qQi0HsunlFVULJmUi6R0JAwIF2S7R1")
    for index in 1...21 {
      client.enqueue(TrackMessageBuilder(event: "hello, world" + String(index)).userId("prateek"))
      client.enqueue(TrackMessageBuilder(event: "bye, world" + String(index)).userId("prateek"))
    }
    
    println("Sent messages to client.")
    
    client.blockingFlush()
    
    println("Triggered explicit flush.")
  }
}
