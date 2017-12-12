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

public class GroupMessageBuilder: MessageBuilder {
    private var dictionary: [String: Any] = [:]
  
    public init(groupId: String) {
        dictionary["type"] = "group"
        dictionary["groupId"] = groupId
    }
  
    public func traits(_ traits: [String: Any]) {
        dictionary["traits"] = traits
    }
  
    // Common

    public func userId(_ userId: String) {
        dictionary["userId"] = userId
    }
  
    public func anonymousId(_ anonymousId: String) {
        dictionary["anonymousId"] = anonymousId
    }
  
    public func context(_ context: [String: Any]) {
        dictionary["context"] = context
    }
  
    public func build() -> [String: Any] {
        return dictionary
    }
}
