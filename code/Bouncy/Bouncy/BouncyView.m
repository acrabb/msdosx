//
//  BouncyView.m
//  Bouncy
//
//  Created by Amir Khodaei on 9/19/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import "BouncyView.h"
#import "BouncyViewController.h"

@implementation BouncyView

@synthesize ourViewController = _ourViewController;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    //Outline the frame of the view.
    [[NSColor blackColor] setStroke];
    [[NSColor greenColor] setFill];
    NSBezierPath* framePath = [NSBezierPath bezierPathWithRect:[self bounds]];
    [framePath stroke];
    
    //Draw all balls in _balls array.
    for (NSInteger i=0; i< [_ourViewController askModelForNumberOfBalls]; i++) {
        CGRect ballBounds = [_ourViewController askModelForBallBounds:i];
        NSBezierPath* circlePath = [NSBezierPath bezierPathWithOvalInRect:ballBounds];
        [circlePath setLineWidth:4.0];
        [circlePath fill];
        [circlePath stroke];
    }
    
    
    
}

@end
