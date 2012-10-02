//
//  BouncyViewController.h
//  Bouncy
//
//  Created by Amir Khodaei on 9/19/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BouncyView.h"
#import "BouncyModel.h"

@interface BouncyViewController : NSViewController
{
    @private
    IBOutlet BouncyView* _ourView;
    BouncyModel* _ourModel;
    NSTimer* _timer;
    IBOutlet NSButton* _startStopButton;
}

@property BOOL running;
@property (assign) IBOutlet NSTextField *numBallsLabel;

-(NSInteger)askModelForNumberOfBalls;
-(CGRect)askModelForBallBounds:(NSInteger)whichBall;
-(void)timerFireMethod:(NSTimer*)theTimer;
- (IBAction)ballsSliderMoved:(NSSlider*)sender;
- (IBAction)startStopButtonPressed:(NSButton*)sender;


@end
