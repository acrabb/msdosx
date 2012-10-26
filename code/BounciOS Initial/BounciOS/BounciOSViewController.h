//
//  BounciOSViewController.h
//  BounciOS
//
//  Created by Class Account on 10/1/12.
//  Copyright (c) 2012 UC:Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BounciOSView.h"
#import "BouncyModel.h"

@interface BounciOSViewController : UIViewController
{
    @private
    BouncyModel* _ourModel;
    NSTimer* _timer;
    BOOL _running;
}

@property (retain) IBOutlet BounciOSView* ourView;

-(NSInteger)askModelForNumberOfBalls;
-(CGRect)askModelForBallBounds:(NSInteger)whichBall;
-(IBAction)ballsSliderMoved:(UISlider*)sender;
-(IBAction)speedSliderMoved:(UISlider*)sender;
-(IBAction)startStopButtonPressed:(UIButton*)sender;
-(IBAction)wrapCheckBoxPressed:(UISwitch*)sender;
-(BOOL)askModelForWrapping;

@end
