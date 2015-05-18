//
//  Client.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-14.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public class Client {
  var writeKey: String
  var messageQueue: Array<Dictionary<String, AnyObject>>
  
  public init(writeKey: String) {
    self.writeKey = writeKey
    self.messageQueue = Array()
  }
  
  static func request(url: String) -> NSMutableURLRequest {
    return NSMutableURLRequest(URL: NSURL(string: url)!)
  }
  
  static func now() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter.stringFromDate(NSDate())
  }
  
  public func enqueue(messageBuilder: MessageBuilder) {
    var message = messageBuilder.build()
    message["messageId"] = NSUUID().UUIDString
    message["timestamp"] = Client.now()
    messageQueue.append(message)
    
    if(messageQueue.count >= 10) {
      flush()
    }
  }
  
  func flush() {
    let messageCount = messageQueue.count
    var batch = Dictionary<String, AnyObject>()
    batch["batch"] = messageQueue
    batch["context"] = ["library" : ["name": "analytics-swift", "version": "1.0.0"]]
    
    let urlRequest = Client.request("https://api.segment.io/v1/import")
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
