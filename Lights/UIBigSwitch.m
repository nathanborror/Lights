//
//  UIBigSwitch.m
//  Lights
//
//  Created by Nathan Borror on 9/8/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "UIBigSwitch.h"

static const CGFloat kBackgroundAnimationDuration = .75;
static const CGFloat kBorderWidth = 2.5;

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

    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [background setBackgroundColor:[UIColor whiteColor]];
    [background.layer setBorderColor:[UIColor colorWithWhite:.9 alpha:1].CGColor];
    [background.layer setBorderWidth:kBorderWidth];
    [background.layer setCornerRadius:CGRectGetWidth(background.bounds)/2];
    [self addSubview:background];

    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [mask setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
    [mask.layer setCornerRadius:CGRectGetWidth(mask.bounds)/2];
    [mask.layer setAffineTransform:CGAffineTransformMakeScale(0, 0)];
    [self addSubview:mask];

    thumb = [[UIView alloc] initWithFrame:CGRectMake(kBorderWidth, kBorderWidth, CGRectGetWidth(self.bounds)-(kBorderWidth*2), CGRectGetWidth(self.bounds)-(kBorderWidth*2))];
    [thumb setBackgroundColor:[UIColor whiteColor]];
    [thumb.layer setCornerRadius:CGRectGetWidth(thumb.bounds)/2];
    [thumb.layer setBorderColor:[UIColor colorWithWhite:0 alpha:.1].CGColor];
    [thumb.layer setBorderWidth:1];
    [thumb.layer setShadowColor:[UIColor blackColor].CGColor];
    [thumb.layer setShadowOffset:CGSizeMake(0, 10)];
    [thumb.layer setShadowOpacity:.1];
    [thumb.layer setShadowRadius:5];
    [self addSubview:thumb];

    thumbOff = CGPointMake(thumb.center.x, (CGRectGetHeight(self.bounds)-CGRectGetHeight(thumb.bounds)/2)-kBorderWidth);
    thumbOn = CGPointMake(thumb.center.x, (CGRectGetHeight(thumb.bounds)/2)+kBorderWidth);

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
      [background.layer setBorderColor:[UIColor colorWithWhite:.9 alpha:1].CGColor];
      [mask setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
    } else {
      _on = YES;
      [background.layer setBorderColor:[UIColor colorWithRed:.26 green:.84 blue:.32 alpha:1].CGColor];
      [mask setBackgroundColor:[UIColor colorWithRed:.26 green:.84 blue:.32 alpha:1]];
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  }

  // Animate Thumb
  [UIView animateWithDuration:.9 delay:0 usingSpringWithDamping:.65 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveLinear animations:^{
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
