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
  
  public func track(event: String, properties: Dictionary<String, AnyObject>) {
    var track = NSMutableDictionary()
    track["type"] = "track";
    track["userId"] = "prateek";
    track["messageId"] = NSUUID().UUIDString;
    track["event"] = event;
    track["properties"] = properties;
    upload(track)
  }
  
  public func identify(userId: String, traits: Dictionary<String, Any>) {
    
  }
}
