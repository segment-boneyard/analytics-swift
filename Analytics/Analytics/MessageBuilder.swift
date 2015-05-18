//
//  MessageBuilder.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

public protocol MessageBuilder {
  func build() -> Dictionary<String, AnyObject>
}