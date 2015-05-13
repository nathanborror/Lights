//
//  ViewController.swift
//  Lights
//
//  Created by Nathan Borror on 2/2/15.
//  Copyright (c) 2015 Nathan Borror. All rights reserved.
//

import UIKit
import Alamofire
import LightKit

class ViewController: UIViewController {

    struct Settings {
        static let width:CGFloat = 44.0
        static let height:CGFloat = 44.0
    }

    var lightSwitch:Switch!
    var settingsButton = UIButton()

    let settingsAlert = UIAlertController(title: "Change IP Address", message: nil, preferredStyle: .Alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()

        lightSwitch = Switch(frame: CGRect(x: (Width(self.view) / 2.0) - 64.0, y: (Height(self.view) / 2.0)-100.0, width: 128.0, height: 200.0))
        lightSwitch.addTarget(self, action: "handleSwitch", forControlEvents: .TouchUpInside)
        self.view.addSubview(lightSwitch)

        settingsButton.setImage(UIImage(named: "Settings")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        settingsButton.addTarget(self, action: "handleSettings", forControlEvents: .TouchUpInside)
        settingsButton.tintColor = UIColor.whiteColor()
        self.view.addSubview(settingsButton)

        settingsAlert.addTextFieldWithConfigurationHandler { (field) -> Void in
            field.keyboardAppearance = UIKeyboardAppearance.Dark
            field.keyboardType = UIKeyboardType.DecimalPad
            field.placeholder = (NSUserDefaults.standardUserDefaults().objectForKey("ip") as? String) ?? "10.0.1.1"
        }

        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        settingsAlert.addAction(cancel)

        let save = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let field = self.settingsAlert.textFields?.first as? UITextField {
                API.shared.setIP(field.text)
            }
        }
        settingsAlert.addAction(save)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        settingsButton.frame = CGRect(x: Width(self.view) - Settings.width, y: Height(self.view) - Settings.height, width: Settings.width, height: Settings.height)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func handleSwitch() {
        if self.lightSwitch.isOn {
            API.shared.on(error: self.handleError)
        } else {
            API.shared.off(error: self.handleError)
        }
    }

    func handleError(code: APIErrorCode, description: String) {
        if code == .IPFail {
            self.presentViewController(self.settingsAlert, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: "Connection error", message: description, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }

    func handleSettings() {
        self.presentViewController(settingsAlert, animated: true, completion: nil)
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == UIEventSubtype.MotionShake {
            API.shared.refresh(error: self.handleError)
        }
    }

}

