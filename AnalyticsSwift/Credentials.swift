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

/** Factory for HTTP authorization credentials. Exposed for testing. */
open class Credentials {
  
  /** Returns this string encoded as Base64. */
  fileprivate static func base64(_ string: String) -> String {
    let utf8str = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    return utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
  }
  
  /** Returns an auth credential for the Basic scheme. Exposed for testing. */
  open static func basic(_ username: String, password: String) -> String {
    return String(format: "Basic %@", base64(String(format: "%@:%@", username, password)))
  }

}
