//
//  BouncyViewController.h
//  Bouncy
//
// This source code is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
// or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import <Cocoa/Cocoa.h>

#import "BouncyView.h"
#import "BouncyModel.h"

@interface BouncyViewController : NSViewController
{
@private
    BouncyView* _ourView;
    BouncyModel* _ourModel;
    NSTimer* _timer;
    BOOL _running;
}

@property (retain) IBOutlet BouncyView* _ourView;

-(NSInteger)askModelForNumberOfBalls;
-(CGRect)askModelForBallBounds:(NSInteger) whichBall;
-(IBAction)ballsSliderMoved:(NSSlider*)sender;
-(IBAction)speedSliderMoved:(NSSlider*)sender;
-(IBAction)startStopButtonPressed:(NSButton*)sender;
-(IBAction)wrapCheckBoxPressed:(NSButton*)sender;
-(BOOL)askModelForWrapping;
@end
