//
//  SerialExecutor.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-18.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

import Foundation

class SerialExecutor {
  
  var dispatcher: dispatch_queue_t
  
  init(name: String) {
    self.dispatcher = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL)
  }
  
  func async(closure: () -> ()) {
    dispatch_async(dispatcher) {
      closure()
    }
  }
  
  func sync(closure: () -> ()) {
    dispatch_sync(dispatcher) {
      closure()
    }
  }
}