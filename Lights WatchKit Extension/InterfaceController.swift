//
//  InterfaceController.swift
//  Lights WatchKit Extension
//
//  Created by Nathan Borror on 4/30/15.
//  Copyright (c) 2015 Nathan Borror. All rights reserved.
//

import WatchKit
import Foundation
import LightKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var on:WKInterfaceButton!
    @IBOutlet weak var off:WKInterfaceButton!

    var isOn = false

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func flip() {
        if isOn {
            API.shared.off(error: nil)
            self.isOn = false
        } else {
            API.shared.on(error: nil)
            self.isOn = true
        }
    }
}
