//
//  ViewController.swift
//  AnalyticsSample
//
//  Created by Prateek Srivastava on 2015-05-20.
//  Copyright (c) 2015 Segment. All rights reserved.
//

import Cocoa
import Analytics

class ViewController: NSViewController {
  
  var analytics: Analytics?

  override func viewDidLoad() {
    super.viewDidLoad()

    analytics = Analytics.create("Z2qQi0HsunlFVULJmUi6R0JAwIF2S7R1")
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  @IBAction func buttonAClicked(sender: AnyObject) {
    analytics?.enqueue(TrackMessageBuilder(event: "Button A").userId("prateek"))
  }
  
  @IBAction func buttonBClicked(sender: AnyObject) {
    analytics?.enqueue(TrackMessageBuilder(event: "Button B").userId("prateek"))
  }
  
  @IBAction func homeScreenClicked(sender: AnyObject) {
    analytics?.enqueue(ScreenMessageBuilder(name: "Home").userId("prateek"))
  }
  
  @IBAction func buttonFlushClicked(sender: AnyObject) {
    analytics?.flush()
  }
  
}

