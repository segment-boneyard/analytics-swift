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
 The entry point into the Segment for Java library.
 <p>
 The idea is simple: one pipeline for all your data. Segment is the single hub to collect,
 translate and route your data with the flip of a switch.
 <p>
 Analytics for Swift will automatically batch events and upload it periodically to Segment's
 servers for you. You only need to instrument Segment once, then flip a switch to install
 new tools.
 <p>
 This class is the main entry point into the client API. Use {@link #create} to construct your
 own instances.

 @see <a href="https://Segment/">Segment</a>
*/
public class Analytics {
  var writeKey: String
  var messageQueue: Array<Dictionary<String, AnyObject>>
  var executor: Executor
  
  public static func create(writeKey: String) -> Analytics {
    let executor = SerialExecutor(name:"com.segment.executor." + writeKey)
    let queue = Array<Dictionary<String, AnyObject>>()
    return Analytics(writeKey: writeKey, queue: queue, executor: executor)
  }
  
  public init(writeKey: String, queue: Array<Dictionary<String,AnyObject>>, executor: Executor) {
    self.writeKey = writeKey
    self.messageQueue = queue
    self.executor = executor
  }
  
  static func ensureId(message: Dictionary<String, AnyObject>) {
    if message.indexForKey("userId") == nil && message.indexForKey("anonymousId") == nil {
      NSException(name: "Assertion Failed", reason: "Either userId or anonymousId must be provided.", userInfo: message).raise()
    }
  }
  
  func request(url: String) -> NSMutableURLRequest {
    return NSMutableURLRequest(URL: NSURL(string: url)!)
  }
  
  func now() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter.stringFromDate(NSDate())
  }
  
  public func enqueue(messageBuilder: MessageBuilder) {
    var message = messageBuilder.build()
    Analytics.ensureId(message)
    message["messageId"] = NSUUID().UUIDString
    message["timestamp"] = now()
    
    executor.submit() {
      self.messageQueue.append(message)
      if(self.messageQueue.count >= 10) {
        self.performFlush()
      }
    }
  }
  
  public func flush() {
    executor.submit() {
      self.performFlush()
    }
  }
  
  func performFlush() {
    let messageCount = messageQueue.count
    var batch = Dictionary<String, AnyObject>()
    batch["batch"] = messageQueue
    batch["context"] = ["library" : ["name": "analytics-swift", "version": AnalyticsVersionNumber]]
    
    let urlRequest = request("https://api.segment.io/v1/import")
    urlRequest.HTTPMethod = "post";
    urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(Credentials.basic(writeKey, password: ""), forHTTPHeaderField: "Authorization")
    
    var jsonError: NSError?
    let decodedJson = NSJSONSerialization.dataWithJSONObject(batch, options: nil, error: &jsonError)
    if jsonError != nil {
      println("Failed to serialize messages. Dropping \(messageCount) messages.")
      messageQueue.removeAll(keepCapacity: true)
      return
    }
    urlRequest.HTTPBody = decodedJson
    
    println("Uploading \(messageCount) messages.")
    
    var networkError: NSError?
    var response: NSURLResponse?
    NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response, error: &networkError)
    if networkError != nil {
      println("Failed to upload messages. Retrying later.")
      return
    }
    
    messageQueue.removeAll(keepCapacity: true)
  }
}
