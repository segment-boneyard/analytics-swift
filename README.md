# analytics-swift [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

analytics-swift is an Swift client for [Segment](https://segment.com).

Our [analytics-ios](https://github.com/segmentio/analytics-ios) library is more full featured than it's Swift counterpart. You can use analytics-ios from a Swift project.

The analytics-ios library supports the following features that are *NOT* offered in the Swift library:

* Queing events offline. Without this, the swift library will drop events once the user closes the app or when the user is offline.
* Client side integrations. Without this, some integrations (such as Flurry, Localytics and others) cannot be used with the Swift library.


<div align="center">
  <img src="https://user-images.githubusercontent.com/16131737/53616285-bcca0480-3b96-11e9-8bcd-9874dbe99250.png"/>
  <p><b><i>You can't fix what you can't measure</i></b></p>
</div>

Analytics helps you measure your users, product, and business. It unlocks insights into your app's funnel, core business metrics, and whether you have product-market fit.

## How to get started
1. **Collect analytics data** from your app(s).
    - The top 200 Segment companies collect data from 5+ source types (web, mobile, server, CRM, etc.).
2. **Send the data to analytics tools** (for example, Google Analytics, Amplitude, Mixpanel).
    - Over 250+ Segment companies send data to eight categories of destinations such as analytics tools, warehouses, email marketing and remarketing systems, session recording, and more.
3. **Explore your data** by creating metrics (for example, new signups, retention cohorts, and revenue generation).
    - The best Segment companies use retention cohorts to measure product market fit. Netflix has 70% paid retention after 12 months, 30% after 7 years.

[Segment](https://segment.com) collects analytics data and allows you to send it to more than 250 apps (such as Google Analytics, Mixpanel, Optimizely, Facebook Ads, Slack, Sentry) just by flipping a switch. You only need one Segment code snippet, and you can turn integrations on and off at will, with no additional code. [Sign up with Segment today](https://app.segment.com/signup).

### Why?
1. **Power all your analytics apps with the same data**. Instead of writing code to integrate all of your tools individually, send data to Segment, once.

2. **Install tracking for the last time**. We're the last integration you'll ever need to write. You only need to instrument Segment once. Reduce all of your tracking code and advertising tags into a single set of API calls.

3. **Send data from anywhere**. Send Segment data from any device, and we'll transform and send it on to any tool.

4. **Query your data in SQL**. Slice, dice, and analyze your data in detail with Segment SQL. We'll transform and load your customer behavioral data directly from your apps into Amazon Redshift, Google BigQuery, or Postgres. Save weeks of engineering time by not having to invent your own data warehouse and ETL pipeline.

    For example, you can capture data on any app:
    ```js
    analytics.track('Order Completed', { price: 99.84 })
    ```
    Then, query the resulting data in SQL:
    ```sql
    select * from app.order_completed
    order by price desc
    ```

### 🚀 Startup Program
<div align="center">
  <a href="https://segment.com/startups"><img src="https://user-images.githubusercontent.com/16131737/53128952-08d3d400-351b-11e9-9730-7da35adda781.png" /></a>
</div>
If you are part of a new startup  (&lt;$5M raised, &lt;2 years since founding), we just launched a new startup program for you. You can get a Segment Team plan  (up to <b>$25,000 value</b> in Segment credits) for free up to 2 years — <a href="https://segment.com/startups/">apply here</a>!

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
