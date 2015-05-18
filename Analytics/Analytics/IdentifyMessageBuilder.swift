//
//  IdentifyMessageBuilder.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public class IdentifyMessageBuilder: MessageBuilder {
  private var dictionary: Dictionary<String, AnyObject>
  
  public init() {
    dictionary = Dictionary()
    
    dictionary["type"] = "identify"
  }
  
  public func traits(traits: Dictionary<String, AnyObject>) -> IdentifyMessageBuilder {
    dictionary["traits"] = traits
    return self
  }
  
  // Common
  public func userId(userId: String) -> IdentifyMessageBuilder {
    dictionary["userId"] = userId
    return self
  }
  
  public func anonymousId(anonymousId: String) -> IdentifyMessageBuilder {
    dictionary["anonymousId"] = anonymousId
    return self
  }
  
  public func context(context: Dictionary<String, AnyObject>) -> IdentifyMessageBuilder {
    dictionary["context"] = context
    return self
  }
  
  public func build() -> Dictionary<String, AnyObject> {
    return dictionary
  }
}
