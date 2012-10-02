//
//  BounciOSView.m
//  Bouncy
//
//  Created by Class Account on 10/1/12.
//  Copyright (c) 2012 UC:Berkeley. All rights reserved.
//

#import "BounciOSViewController.h"

@implementation BounciOSView

@synthesize ourViewController = _ourViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSInteger numberOfBalls = [_ourViewController askModelForNumberOfBalls];
    
    [[UIColor blackColor] setStroke];
    
    if ( [_ourViewController askModelForWrapping] == NO )
    {
        UIBezierPath* framePath = [UIBezierPath bezierPathWithRect: [self bounds]];
        
        [framePath stroke];
    }
    
    for ( NSInteger ballIndex = 0; ballIndex < numberOfBalls; ballIndex++ )
    {
        CGRect ballBounds = [_ourViewController askModelForBallBounds:ballIndex];
        
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect: ballBounds];
        
        [circlePath setLineWidth:(CGFloat)4.0];
        
        [circlePath fill];
        
        [circlePath stroke];
    }

    
}
/**/

@end
