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

@synthesize numBallsLabel = _numBallsLabel;
@synthesize running = _running;

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
    
    self.running = YES;
    [_startStopButton setTitle:@"Press me!"];
    
    [_ourModel createAndAddNewBall];
    self.numBallsLabel.intValue = [_ourModel numberOfBalls];
}


-(void)timerFireMethod:(NSTimer*)theTimer {
    NSLog(@"In timerFireMethod");
    if (self.running) {
        [_ourModel handleCollisions];
        [_ourModel updateBallPositions];
        [_ourView setNeedsDisplay:YES];
    }
}

- (IBAction)ballsSliderMoved:(NSSlider*)sender {
    NSLog(@"%@'s value is now %d", sender,[sender intValue]);
    
    NSInteger value = [sender intValue];
    [_ourModel changeNumberOfBalls:value];
    self.numBallsLabel.intValue = [_ourModel numberOfBalls];
}


- (IBAction)startStopButtonPressed:(NSButton*)sender {
    self.running = !self.running;
    
    if(self.running) {
        [sender setTitle:@"STOP"];
    }
    else {
        [sender setTitle:@"GO!"];
    }
    
}
@end
