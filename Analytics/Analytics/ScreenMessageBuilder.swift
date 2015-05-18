//
//  ScreenMessageBuilder.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public class ScreenMessageBuilder: MessageBuilder {
  private var dictionary: Dictionary<String, AnyObject>
  
  public init(name: String) {
    dictionary = Dictionary()
    
    dictionary["type"] = "screen"
    dictionary["name"] = name
  }
  
  public func properties(properties: Dictionary<String, AnyObject>) -> ScreenMessageBuilder {
    dictionary["properties"] = properties
    return self
  }
  
  // Common
  public func userId(userId: String) -> ScreenMessageBuilder {
    dictionary["userId"] = userId
    return self
  }
  
  public func anonymousId(anonymousId: String) -> ScreenMessageBuilder {
    dictionary["anonymousId"] = anonymousId
    return self
  }
  
  public func context(context: Dictionary<String, AnyObject>) -> ScreenMessageBuilder {
    dictionary["context"] = context
    return self
  }
  
  public func build() -> Dictionary<String, AnyObject> {
    return dictionary
  }
}
