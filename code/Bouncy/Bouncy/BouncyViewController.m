//
//  BouncyViewController.m
//  Bouncy
//
//  Created by Amir Khodaei on 9/19/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import "BouncyViewController.h"

@interface BouncyViewController ()

@end

@implementation BouncyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(NSInteger)askModelForNumberOfBalls {
    return [_ourModel numberOfBalls];
}


-(CGRect)askModelForBallBounds:(NSInteger)whichBall {
    return [_ourModel ballBounds:whichBall];
}


-(void)awakeFromNib {
    _ourModel = [[BouncyModel alloc] initWithBounds:[_ourView bounds]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/30) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    [_ourModel createAndAddNewBall];
}


-(void)timerFireMethod:(NSTimer*)theTimer {
    [_ourModel updateBallPositions];
    [_ourView setNeedsDisplay:YES];
}


@end
