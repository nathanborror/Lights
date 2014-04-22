//
//  LGPlotter.m
//  Lights
//
//  Created by Nathan Borror on 4/14/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

#import "LGPlotter.h"
#import "NBDirectionGestureRecognizer.h"

static const CGFloat kThumbSize = 44;
static const CGFloat kOutlineThickness = 2;

@implementation LGPlotter {
  UIView *_outline;
  UIButton *_thumb;
  CGPoint _panCoordBegan;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];

    _outline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [_outline.layer setBorderColor:[UIColor blackColor].CGColor];
    [_outline.layer setBorderWidth:kOutlineThickness];
    [_outline.layer setCornerRadius:CGRectGetWidth(self.bounds)/2];
    [self addSubview:_outline];

    _thumb = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-(kThumbSize/2), (CGRectGetHeight(self.bounds)/2)-(kThumbSize/2), kThumbSize, kThumbSize)];
    [_thumb setBackgroundColor:[UIColor redColor]];
    [_thumb.layer setCornerRadius:kThumbSize/2];
    [self addSubview:_thumb];

    NBDirectionGestureRecognizer *pan = [[NBDirectionGestureRecognizer alloc] initWithTarget:self action:@selector(panThumb:)];
    [pan setDirection:NBDirectionPanGestureRecognizerHorizontal];
    [_thumb addGestureRecognizer:pan];
  }
  return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *hitView = [super hitTest:point withEvent:event];
  NSLog(@"%@ : self: %@", hitView, self);
  if (hitView == self) {
    return nil;
  } else {
    return hitView;
  }
}

#pragma mark - NBDirectionGestureRecognizer

- (void)panThumb:(NBDirectionGestureRecognizer *)recognizer
{
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    _panCoordBegan = [recognizer locationInView:_thumb];
  }

  if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint panCoordChange = [recognizer locationInView:_thumb];
    CGFloat deltaX = panCoordChange.x - _panCoordBegan.x;
    CGFloat newX = _thumb.center.x + deltaX;

    if (newX < CGRectGetWidth(self.bounds) && newX > (CGRectGetWidth(self.bounds)/2)+44) {
      [_thumb setCenter:CGPointMake(newX, _thumb.center.y)];

      CGFloat outlineMargin = CGRectGetWidth(self.bounds)-newX;
      CGFloat outlineWidth = CGRectGetWidth(self.bounds)-(outlineMargin*2);

      [_outline setFrame:CGRectMake(outlineMargin, outlineMargin, outlineWidth, outlineWidth)];
      [_outline.layer setCornerRadius:outlineWidth/2];
    }
  }
}

@end
