//
//  TrackMessageBuilder.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public class TrackMessageBuilder: MessageBuilder {
  private var dictionary: Dictionary<String, AnyObject>

  public init(event: String) {
    dictionary = Dictionary()
    
    dictionary["type"] = "track"
    dictionary["event"] = event
  }

  public func properties(properties: Dictionary<String, AnyObject>) -> TrackMessageBuilder {
    dictionary["properties"] = properties
    return self
  }
  
  // Common
  public func userId(userId: String) -> TrackMessageBuilder {
    dictionary["userId"] = userId
    return self
  }
  
  public func anonymousId(anonymousId: String) -> TrackMessageBuilder {
    dictionary["anonymousId"] = anonymousId
    return self
  }
  
  public func context(context: Dictionary<String, AnyObject>) -> TrackMessageBuilder {
    dictionary["context"] = context
    return self
  }
  
  public func build() -> Dictionary<String, AnyObject> {
    return dictionary
  }
  
}
