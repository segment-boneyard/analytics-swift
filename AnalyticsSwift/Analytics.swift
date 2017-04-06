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

/// The entry point into the Analytics for Swift library.
open class Analytics {
  /// The writeKey for the Segment project this client will upload events to.
  var writeKey: String
  /// In memory queue of enqueued events.
  var messageQueue: Array<Dictionary<String, AnyObject>>
  /// Executor that handles interactions with the messageQueue. This will also be used to upload events.
  var executor: Executor
  /// Queue size at which we automatically upload events
  let flushQueueSize = 10
  
  /**
    Initializes a new Analytics client with the provided parameters.
  
    - parameter writeKey: Write Key for your Segment project
  
    - returns: A beautiful, brand-new, custom built Analytics client just for you. ❤️
  */
  open static func create(_ writeKey: String) -> Analytics {
    let executor = SerialExecutor(name:"com.segment.executor." + writeKey)
    let queue = Array<Dictionary<String, AnyObject>>()
    return Analytics(writeKey: writeKey, queue: queue, executor: executor)
  }
  
  /**
    Initializes a new Analytics client with the provided parameters.
  
    - parameter writeKey: Write Key for your Segment project
    - parameter queue: In memory queue of enqueued events.
    - parameter executor: Executor that handles interactions with the messageQueue. This will also be used to upload events.
  
    Exposed for testing only. Do not use this directly.
  */
  public init(writeKey: String, queue: Array<Dictionary<String,AnyObject>>, executor: Executor) {
    self.writeKey = writeKey
    self.messageQueue = queue
    self.executor = executor
  }
  
  /** Ensures that a message provides either one of userId or anonymousId. */
  static func ensureId(_ message: Dictionary<String, AnyObject>) {
    if message.index(forKey: "userId") == nil && message.index(forKey: "anonymousId") == nil {
      NSException(name: NSExceptionName(rawValue: "Assertion Failed"), reason: "Either userId or anonymousId must be provided.", userInfo: message).raise()
    }
  }
  
  /** Returns a NSMutableURLRequest for the given endpoint (relative to https://api.segment.io/v1 by default). */
  func request(_ endpoint: String) -> NSMutableURLRequest {
    return NSMutableURLRequest(url: URL(string: "https://api.segment.io/v1" + endpoint)!)
  }
  
  /** Returns the current time as an ISO 8601 formatted String. */
  func now() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: Date())
  }
  
  /**
    Enqueue the given message to be uploaded to Segment asynchronously.
    This function will call MessageBuilder.build and validate the message.
  
    - parameter messageBuilder: The builder instance used to a create a message. Be sure to provide a userId or anonymousId.
  */
  open func enqueue(_ messageBuilder: MessageBuilder) {
    var message = messageBuilder.build()
    Analytics.ensureId(message)
    message["messageId"] = UUID().uuidString as AnyObject?
    message["timestamp"] = now() as AnyObject?
    
    executor.submit() {
      self.messageQueue.append(message)
      if(self.messageQueue.count >= self.flushQueueSize) {
        self.performFlush()
      }
    }
  }
  
  /** Request the client to upload events. This method will asychronously upload the events, and will not block. */
  open func flush() {
    executor.submit() {
      self.performFlush()
    }
  }
  
  /** Synchronously flush events to Segment. */
  func performFlush() {
    let messageCount = messageQueue.count
    if (messageCount < 1) {
      print("no messages to flush")
      return
    }
    var batch = Dictionary<String, Any>()
    batch["batch"] = messageQueue as Any?
    batch["context"] = ["library" : ["name": "analytics-swift", "version": AnalyticsSwiftVersionNumber]]
    
    let urlRequest = request("/import")
    urlRequest.httpMethod = "post";
    urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(Credentials.basic(writeKey, password: ""), forHTTPHeaderField: "Authorization")
    
    var jsonError: NSError?
    let decodedJson: Data?
    do {
      decodedJson = try JSONSerialization.data(withJSONObject: batch, options: [])
    } catch let error as NSError {
      jsonError = error
      decodedJson = nil
    }
    if jsonError != nil {
      print("Failed to serialize messages. Dropping \(messageCount) messages.")
      messageQueue.removeAll(keepingCapacity: true)
      return
    }
    urlRequest.httpBody = decodedJson
    
    print("Uploading \(messageCount) messages.")
    
    var networkError: NSError?
    var response: URLResponse?
    do {
      try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: &response)
    } catch let error as NSError {
      networkError = error
    }
    if networkError != nil {
      print("Failed to upload messages. Retrying later.")
      return
    }
    
    messageQueue.removeAll(keepingCapacity: true)
  }
}
