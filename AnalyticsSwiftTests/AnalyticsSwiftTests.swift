// The MIT License (MIT)
//
// Copyright © 2015 Segment, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa
import XCTest
import AnalyticsSwift

final class AnalyticsSwiftTests: XCTestCase {
    func testExample() {
        let analytics = Analytics(writeKey: "Z2qQi0HsunlFVULJmUi6R0JAwIF2S7R1", queue: Array(),
                                  executor: SynchronousExecutor(name: "com.segment.executor.test"))
        for index in 1...21 {
            let tmb1 = TrackMessageBuilder(event: "hello, world" + String(index))
            tmb1.setUserId("prateek")
            analytics.enqueue(messageBuilder: tmb1)
            
            let tmb2 = TrackMessageBuilder(event: "bye, world" + String(index))
            tmb2.setUserId("prateek")
            analytics.enqueue(messageBuilder: tmb2)
        }
        print("Sent messages to client.")
        analytics.flush()
        print("Triggered explicit flush.")
    }
}
