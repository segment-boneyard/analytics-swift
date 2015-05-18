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
  
  public init(writeKey: String) {
    self.writeKey = writeKey
  }
  
  public func sayHelloWorld() -> String {
    return "hello, world"
  }
  
  static func request(url: String) -> NSMutableURLRequest {
    return NSMutableURLRequest(URL: NSURL(string: url)!)
  }
  
  func upload(message: Dictionary<String, AnyObject>) {
    var batch = Dictionary<String, AnyObject>()
    batch["batch"] = [message]
    batch["context"] = ["library" : ["name": "analytics-swift", "version": "1.0.0"]]

    let urlRequest = Client.request("https://api.segment.io/v1/import")
    urlRequest.HTTPMethod = "post";
    urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(Credentials.basic(writeKey, password: ""), forHTTPHeaderField: "Authorization")

    var jsonError: NSError?
    let decodedJson = NSJSONSerialization.dataWithJSONObject(batch, options: nil, error: &jsonError)
    if jsonError != nil {
      println("failed")
      return
    }
    urlRequest.HTTPBody = decodedJson
    
    var networkError: NSError?
    var response: NSURLResponse?

    NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response, error: &networkError)
  }
  
  public func enqueue(messageBuilder: MessageBuilder) {
    var message = messageBuilder.build()
    message["messageId"] = NSUUID().UUIDString
    message["timestamp"] = iso8601Date()
    upload(message)
  }
  
  func iso8601Date() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter.stringFromDate(NSDate())
  }
  
}
