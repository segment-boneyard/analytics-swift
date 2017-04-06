// The MIT License (MIT)
//
// Copyright © 2015 Segment, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

open class IdentifyMessageBuilder: MessageBuilder {
  fileprivate var dictionary: Dictionary<String, AnyObject>
  
  public init() {
    dictionary = Dictionary()
    
    dictionary["type"] = "identify" as AnyObject?
  }
  
  open func traits(_ traits: Dictionary<String, AnyObject>) -> IdentifyMessageBuilder {
    dictionary["traits"] = traits as AnyObject?
    return self
  }
  
  // Common
  open func userId(_ userId: String) -> IdentifyMessageBuilder {
    dictionary["userId"] = userId as AnyObject?
    return self
  }
  
  open func anonymousId(_ anonymousId: String) -> IdentifyMessageBuilder {
    dictionary["anonymousId"] = anonymousId as AnyObject?
    return self
  }
  
  open func context(_ context: Dictionary<String, AnyObject>) -> IdentifyMessageBuilder {
    dictionary["context"] = context as AnyObject?
    return self
  }
  
  open func build() -> Dictionary<String, AnyObject> {
    return dictionary
  }
}
