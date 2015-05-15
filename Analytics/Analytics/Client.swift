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
  
  func upload(message: NSDictionary) {
    var batch = Dictionary<String, AnyObject>()
    batch["batch"] = [message];

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
  
  public func identify(userId: String, traits: Dictionary<String, AnyObject>) {
    var identify = NSMutableDictionary()
    identify["type"] = "identify"
    identify["messageId"] = NSUUID().UUIDString
    identify["userId"] = userId
    identify["traits"] = traits
    upload(identify)
  }
  
  public func track(event: String, properties: Dictionary<String, AnyObject>) {
    var track = NSMutableDictionary()
    track["type"] = "track"
    track["messageId"] = NSUUID().UUIDString
    track["userId"] = "prateek"
    track["event"] = event
    track["properties"] = properties
    upload(track)
  }
  
  public func screen(name: String, properties: Dictionary<String, AnyObject>) {
    var screen = NSMutableDictionary()
    screen["type"] = "screen"
    screen["messageId"] = NSUUID().UUIDString
    screen["userId"] = "prateek"
    screen["name"] = name
    screen["properties"] = properties
    upload(screen)
  }
  
  public func alias(userId: String, previousId: String) {
    var screen = NSMutableDictionary()
    screen["type"] = "screen"
    screen["messageId"] = NSUUID().UUIDString
    screen["userId"] = userId
    screen["previousId"] = previousId
    upload(screen)
  }
}
