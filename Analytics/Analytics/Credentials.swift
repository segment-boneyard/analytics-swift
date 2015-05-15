//
//  Credentials.swift
//  Analytics
//
//  Created by Prateek Srivastava on 2015-05-15.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Foundation

class Credentials {
  
  private static func base64(string: String) -> String {
    let utf8str = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
  }
  
  static func basic(username: String, password: String) -> String {
    return String(format: "Basic %@", base64(String(format: "%@:%@", username, password)))
  }

}