//
//  GroupMessageBuilder.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public class GroupMessageBuilder: MessageBuilder {
  private var dictionary: Dictionary<String, AnyObject>
  
  public init(groupId: String) {
    dictionary = Dictionary()
    
    dictionary["type"] = "group"
    dictionary["groupId"] = groupId
  }
  
  public func traits(traits: Dictionary<String, AnyObject>) -> GroupMessageBuilder {
    dictionary["traits"] = traits
    return self
  }
  
  // Common
  public func userId(userId: String) -> GroupMessageBuilder {
    dictionary["userId"] = userId
    return self
  }
  
  public func anonymousId(anonymousId: String) -> GroupMessageBuilder {
    dictionary["anonymousId"] = anonymousId
    return self
  }
  
  public func context(context: Dictionary<String, AnyObject>) -> GroupMessageBuilder {
    dictionary["context"] = context
    return self
  }
  
  public func build() -> Dictionary<String, AnyObject> {
    return dictionary
  }
}
