# analytics-swift 

analytics-swift is an Swift client for [Segment](https://segment.com)

## Installing the Library

#### CocoaPods
```
use_frameworks!

pod 'AnalyticsSwift', '~> 0.2.0'
```

#### Manual
1. Download the [latest binary](https://github.com/segmentio/analytics-swift/releases) of the library.
2. Drag the `AnalyticsSwift.framework` file [into](https://cloudup.com/cBXYVa2ZmOL) your project.
3. Under 'Build Phases', click the ['New Copy Files Phase'](https://cloudup.com/c7pDwmlNnhq) button.
4. In the 'Copy Files' target, select 'Frameworks' as the destination and [drag the `Analytics.framework`](https://cloudup.com/cliU4MKF69U) file from the binary we added to the project in step 2.

## Usage
* Add the `AnalyticsSwift` library to your project.

* Add the correct imports `import AnalyticsSwift`

* Create an instance of the analytics client with your project write key:

`var analytics = Analytics.create(YOUR_SEGMENT_WRITE_KEY_HERE)`

* Create an instance of a message (either [`identify`](https://segment.com/docs/libraries/http/#identify), [`group`](https://segment.com/docs/libraries/http/#group), [`track`](https://segment.com/docs/libraries/http/#track), [`screen`](https://segment.com/docs/libraries/http/#screen), [`alias`](https://segment.com/docs/libraries/http/#alias)). Note that either `userId` or `anonymousId` is always required.

`var message = TrackMessageBuilder(event: "Button A").userId("prateek")`

* Enqueue the message.

`analytics.enqueue(message)`

* Wait for the message to be uploaded or trigger a flush manually.

`analytics.flush()`

## Examples

You can see basic examples of the library in action [here](https://github.com/segmentio/analytics-swift-example).

## License

```
WWWWWW||WWWWWW
 W W W||W W W
      ||
    ( OO )__________
     /  |           \
    /o o|    MIT     \
    \___/||_||__||_|| *
         || ||  || ||
        _||_|| _||_||
       (__|__|(__|__|


(The MIT License)

Copyright (c) 2013 Segment Inc. <friends@segment.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
