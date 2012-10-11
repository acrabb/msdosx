//
//  BounciOSViewController.m
//  BounciOS
//
//  Created by Class Account on 10/1/12.
//  Copyright (c) 2012 UC:Berkeley. All rights reserved.
//

#import "BounciOSViewController.h"

@interface BounciOSViewController ()

@end

@implementation BounciOSViewController

@synthesize ourView = _ourView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _ourModel = [[BouncyModel alloc] initWithBounds:[_ourView bounds]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0)
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];
    
    [_ourModel createAndAddNewBall];
    
    _running = YES;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)dealloc
{
    [_ourModel release];
    [_timer invalidate];
    [_timer release];
    [super dealloc];
}

-(void)timerFireMethod:(NSTimer*)theTimer
{
    if ( _running == true )
    {
        [_ourModel handleCollisions];
        [_ourModel updateBallPositions];
        [_ourView setNeedsDisplay];
    }
}


-(NSInteger)askModelForNumberOfBalls
{
    return [_ourModel numberOfBalls];
}

-(CGRect)askModelForBallBounds:(NSInteger)whichBall
{
    return [_ourModel ballBounds:whichBall];
}

-(BOOL)askModelForWrapping
{
    return [_ourModel wrapping];
}

-(IBAction)wrapCheckBoxPressed:(UISwitch*)sender
{
    [_ourModel wrapping:[sender state]];
}

-(IBAction)ballsSliderMoved:(UISlider*)sender
{
    NSInteger numBalls = [sender value];
    [_ourModel changeNumberOfBalls:numBalls];
}

-(IBAction)speedSliderMoved:(UISlider*)sender
{
    [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/[sender value])
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];
    
}

-(IBAction)startStopButtonPressed:(UIButton*)sender
{
    _running = !_running;
    
    if (_running)
    {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"GO!" forState:UIControlStateNormal];
    }
}




@end
