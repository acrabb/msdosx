//
//  BeatBoxViewController.h
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BeatBoxViewController : UIViewController

@property (nonatomic)	IBOutlet UILabel        *fileName;
@property (nonatomic)	IBOutlet UIButton       *playButton;
@property (nonatomic)   IBOutlet UIButton       *recButton;
@property (nonatomic)   NSURL                   *fileURL;
@property (nonatomic)	AVAudioPlayer           *player;
@property (nonatomic)   AVAudioRecorder         *recorder;
@property               BOOL                    isRecording;

//@property (nonatomic, retain)	UISlider		*volumeSlider;
//@property (nonatomic, retain)	UISlider		*progressBar;
//@property (nonatomic, retain)	UILabel			*currentTime;
//@property (nonatomic, retain)	UILabel			*duration;
//@property (retain)			CALevelMeter	*lvlMeter_in;
//@property (nonatomic, retain)	NSTimer			*updateTimer;
//@property (nonatomic, assign)	BOOL			inBackground;



- (IBAction)recordButtonPushed:(UIButton *)sender;
- (IBAction)playButtonPushed:(UIButton *)sender;

@end
