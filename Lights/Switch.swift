/*
    Switch.swift
    Lights

    Created by Nathan Borror on 2/2/15.
    Copyright (c) 2015 Nathan Borror. All rights reserved.

    Abstract:
        The `Switch` control is a larger vertical version of the `UISwitch`.
*/

import UIKit

class Switch: UIControl {

    struct Style {
        static let borderWidth:CGFloat = 3.0
    }

    struct Animation {
        static let duration:NSTimeInterval = 0.75
        static let delay:NSTimeInterval = 0.0
        static let damping:CGFloat = 0.9
        static let velocity:CGFloat = 0.2
    }

    let background = UIView()
    let mask = UIView()
    let thumb = UIView()

    var cancelled = false
    var isOn = false

    var thumbOff:CGPoint!
    var thumbOn:CGPoint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        mask.frame = CGRect(x: 0.0, y: 0.0, width: Width(self), height: Height(self))
        mask.backgroundColor = UIColor.whiteColor()
        mask.layer.cornerRadius = Width(mask) / 2.0
        mask.layer.setAffineTransform(CGAffineTransformMakeScale(0, 0))
        self.addSubview(mask)

        background.frame = CGRect(x: 0.0, y: 0.0, width: Width(self), height: Height(self))
        background.layer.cornerRadius = Width(background) / 2.0
        background.layer.borderColor = UIColor.whiteColor().CGColor
        background.layer.borderWidth = Style.borderWidth
        self.addSubview(background)

        thumb.frame = CGRect(x: Style.borderWidth, y: Style.borderWidth, width: Width(self) - (Style.borderWidth * 2.0), height: Width(self)-(Style.borderWidth * 2.0))
        thumb.layer.cornerRadius = Width(thumb) / 2.0
        thumb.backgroundColor = UIColor.whiteColor()
        thumb.layer.borderColor = UIColor.blackColor().CGColor
        thumb.layer.borderWidth = Style.borderWidth / 2.0
        self.addSubview(thumb)

        thumbOff = CGPoint(x: background.center.x, y: (Height(self) - Height(thumb) / 2.0) - Style.borderWidth)
        thumbOn = CGPoint(x: background.center.x, y: (Height(thumb) / 2.0) + Style.borderWidth)

        thumb.center = thumbOff
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setState(on: Bool) {
        self.animate({ () -> Void in
            self.thumb.frame = CGRect(x: MinX(self.thumb), y: MinY(self.thumb) - 20.0, width: Width(self.thumb), height: Height(self.thumb) - 20.0)
            if on {
                self.thumb.center = self.thumbOn
            } else {
                self.thumb.center = self.thumbOff
            }
        })

        self.animate({ () -> Void in
            if !on {
                self.mask.layer.setAffineTransform(CGAffineTransformMakeScale(0.0, 0.0))
            }
        })
    }

    func animate(animate: () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(Animation.duration, delay: Animation.delay, usingSpringWithDamping: Animation.damping, initialSpringVelocity: Animation.velocity, options: UIViewAnimationOptions.CurveLinear, animations: animate, completion: completion)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        UIView.animateWithDuration(Animation.duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .CurveLinear, animations: { () -> Void in
            if self.isOn {
                self.thumb.frame = CGRect(x: MinX(self.thumb), y: MinY(self.thumb), width: Width(self.thumb), height: Height(self.thumb) + 20.0)
            } else {
                self.mask.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))
                self.thumb.frame = CGRect(x: MinX(self.thumb), y: MinY(self.thumb) - 20.0, width: Width(self.thumb), height: Height(self.thumb) + 20.0)
            }
        }, completion: nil)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let point = (touches.first as? UITouch)?.locationInView(self) {
            if self.pointInside(point, withEvent: nil) {
                self.isOn = !self.isOn
                self.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            }

            self.setState(self.isOn)
        }
    }

}
