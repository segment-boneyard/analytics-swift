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
  
  static func base64(string: String) -> String {
    let utf8str = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
  }
  
  static func authHeaderValue(writeKey: String) -> String {
    return String(format: "Basic %@", base64(String(format: "%@:", writeKey)))
  }
  
  static func request(url: String) -> NSMutableURLRequest {
    return NSMutableURLRequest(URL: NSURL(string: url)!)
  }
  
  func upload(message: NSDictionary) {
    var batch = NSMutableDictionary()
    batch["batch"] = [message];

    let urlRequest = Client.request("https://api.segment.io/v1/import")
    urlRequest.HTTPMethod = "post";
    urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(Client.authHeaderValue(writeKey), forHTTPHeaderField: "Authorization")

    var jsonError: NSError?
    let decodedJson = NSJSONSerialization.dataWithJSONObject(batch, options: nil, error: &jsonError)
    if jsonError != nil {
      println("failed")
    }
    urlRequest.HTTPBody = decodedJson
    
    var networkError: NSError?
    var response: NSURLResponse?

    NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response, error: &networkError)
  }
  
  public func track(event: String) {
    var track = NSMutableDictionary()
    track["type"] = "track";
    track["userId"] = "prateek";
    track["messageId"] = "foo";
    track["event"] = event;
    upload(track)
  }
}
