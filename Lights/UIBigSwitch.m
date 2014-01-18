//
//  UIBigSwitch.m
//  Lights
//
//  Created by Nathan Borror on 9/8/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "UIBigSwitch.h"

static const CGFloat kBackgroundAnimationDuration = .75;
static const CGFloat kBorderWidth = 3;

@implementation UIBigSwitch {
  UIView *background;
  UIView *mask;
  UIView *thumb;
  BOOL cancelled;

  CGPoint thumbOff;
  CGPoint thumbOn;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _on = NO;

    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [mask setBackgroundColor:[UIColor whiteColor]];
    [mask.layer setCornerRadius:CGRectGetWidth(mask.bounds)/2];
    [mask.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];
    [self addSubview:mask];

    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [background.layer setBorderColor:[UIColor whiteColor].CGColor];
    [background.layer setBorderWidth:kBorderWidth];
    [background.layer setCornerRadius:CGRectGetWidth(background.bounds)/2];
    [self addSubview:background];

    thumb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)-(kBorderWidth*2), CGRectGetWidth(self.bounds)-(kBorderWidth*2))];
    [thumb setBackgroundColor:[UIColor whiteColor]];
    [thumb.layer setCornerRadius:CGRectGetWidth(thumb.bounds)/2];
    [thumb.layer setBorderColor:[UIColor blackColor].CGColor];
    [thumb.layer setBorderWidth:kBorderWidth/2];
    [self addSubview:thumb];

    thumbOff = CGPointMake(background.center.x, (CGRectGetHeight(self.bounds)-CGRectGetHeight(thumb.bounds)/2)-kBorderWidth);
    thumbOn = CGPointMake(background.center.x, (CGRectGetHeight(thumb.bounds)/2)+kBorderWidth);

    [thumb setCenter:thumbOff];
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [UIView animateWithDuration:kBackgroundAnimationDuration delay:0 usingSpringWithDamping:.9 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveLinear animations:^{
    if (_on) {
      [thumb setFrame:CGRectMake(CGRectGetMinX(thumb.frame), CGRectGetMinY(thumb.frame), CGRectGetWidth(thumb.bounds), CGRectGetHeight(thumb.bounds)+20)];
    } else {
      [mask.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
      [thumb setFrame:CGRectMake(CGRectGetMinX(thumb.frame), CGRectGetMinY(thumb.frame)-20, CGRectGetWidth(thumb.bounds), CGRectGetHeight(thumb.bounds)+20)];
    }
  } completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint point = [touches.anyObject locationInView:self];

  if ([self pointInside:point withEvent:nil]) {
    if (_on) {
      _on = NO;
    } else {
      _on = YES;
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  }

  // Animate Thumb
  [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveLinear animations:^{
    [thumb setFrame:CGRectMake(CGRectGetMinX(thumb.frame), CGRectGetMinY(thumb.frame), CGRectGetWidth(thumb.bounds), CGRectGetHeight(thumb.bounds)-20)];
    if (_on) {
      [thumb setCenter:thumbOn];
    } else {
      [thumb setCenter:thumbOff];
    }
  } completion:nil];

  // Animate Mask
  [UIView animateWithDuration:kBackgroundAnimationDuration delay:.2 usingSpringWithDamping:.9 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveLinear animations:^{
    if (!_on) {
      [mask.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];
    }
  } completion:^(BOOL finished) {

  }];
}

@end
