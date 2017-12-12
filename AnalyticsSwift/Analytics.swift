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

import Foundation

/**
 The entry point into the Analytics for Swift library.
*/

public class Analytics {

    /** 
    The writeKey for the Segment project this client will upload events to.
    */

    private let writeKey: String

    /**
     In memory queue of enqueued events.
    */

    private var messageQueue: [[String: Any]]

    /** 
     Executor that handles interactions with the messageQueue. This will also be used to upload events.
    */

    private let executor: Executor

    /** 
     Queue size at which we automatically upload events
    */

    private let flushQueueSize = 10

    // MARK: Public interface
  
    /**
     Initializes a new Analytics client with the provided parameters.
     - parameter writeKey: Write Key for your Segment project
     - returns: A beautiful, brand-new, custom built Analytics client just for you. ❤️
    */

    public static func create(writeKey: String) -> Analytics {
        let executor = SerialExecutor(name:"com.segment.executor." + writeKey)
        return Analytics(writeKey: writeKey, queue: [], executor: executor)
    }
  
    /**
     Initializes a new Analytics client with the provided parameters.
     - parameter writeKey: Write Key for your Segment project
     - parameter queue: In memory queue of enqueued events.
     - parameter executor: Executor that handles interactions with the messageQueue. This will also be used to upload events.
     Exposed for testing only. Do not use this directly.
    */

    public init(writeKey: String, queue: [[String: Any]], executor: Executor) {
        self.writeKey = writeKey
        self.messageQueue = queue
        self.executor = executor
    }

    /**
     Enqueue the given message to be uploaded to Segment asynchronously.
     This function will call MessageBuilder.build and validate the message.
     - parameter messageBuilder: The builder instance used to a create a message. Be sure to provide a userId or anonymousId.
    */

    public func enqueue(messageBuilder: MessageBuilder) {
        var message = messageBuilder.build()
        Analytics.ensureId(message: message)
        message["messageId"] = UUID().uuidString
        message["timestamp"] = now
        executor.submit {
            self.messageQueue.append(message)
            if self.messageQueue.count >= self.flushQueueSize {
                self.performFlush()
    }
        }
    }

    /**
     Request the client to upload events. This method will asychronously upload the events, and will not block.
    */

    public func flush() {
        executor.submit(task: performFlush)
    }

    // MARK: Private methods
  
    /** 
     Ensures that a message provides either one of userId or anonymousId. 
    */

    private static func ensureId(message: [String: Any]) {
        let idExists = message.keys.contains("userId") || message.keys.contains("anonymousId")
        assert(idExists, "Either userId or anonymousId must be provided.")
    }
  
    /** 
     Returns a URLRequest for the given endpoint (relative to https://api.segment.io/v1 by default).
    */

    private func request(endpoint: String) -> URLRequest {
        return URLRequest(url: URL(string: "https://api.segment.io/v1" + endpoint)!)
    }
  
    /** 
     Returns the current time as an ISO 8601 formatted String. 
    */

    private var now: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }
  
    /** 
     Synchronously flush events to Segment. 
    */

    private func performFlush() {
        guard messageQueue.count > 0 else {
            print("No messages to flush")
            return
        }
        guard let messagesData = messagesData else {
            print("Failed to serialize messages. Dropping \(messageQueue.count) messages.")
            messageQueue.removeAll(keepingCapacity: true)
            return
        }
        let request = urlRequest(for: messagesData)
        print("Uploading \(messageQueue.count) messages.")
        URLSession.shared.dataTask(with: request).resume()
        messageQueue.removeAll(keepingCapacity: true)
    }

    /**
     Returns serialized events.
    */

    private var messagesData: Data? {
        let batch: [String: Any] = [
            "batch": messageQueue,
            "context": [
                "library": [
                    "name": "analytics-swift",
                    "version": AnalyticsSwiftVersionNumber
                ]
            ]
        ]
        return try? JSONSerialization.data(withJSONObject: batch, options: [])
    }

    /**
     Returns URLRequest to be fired to send events to Segment.
    */

    private func urlRequest(for messagesData: Data) -> URLRequest {
        var urlRequest = request(endpoint: "/import")
        urlRequest.httpMethod = "post"
        urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Credentials.basic(username: writeKey, password: ""), forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = messagesData
        return urlRequest
    }
}
