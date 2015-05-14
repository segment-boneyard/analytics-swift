//
//  Analytics.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-14.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation
import Alamofire

public class Client {
  public init() { }

  public func settings() {
    Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
      .response { (request, response, data, error) in
        println(request)
        println(response)
        println(error)
    }
  }
}