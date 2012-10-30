//
//  BeatBitsViewController.h
//  BeatBits
//
//  Created by Amir Khodaei on 10/22/12.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface BeatBitsViewController : UIViewController <AVAudioRecorderDelegate>

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property IBOutlet UILabel *recordStateLabel;

@property BOOL isRecording;


-(IBAction)recording:(id)sender;
-(IBAction)playback:(id)sender;


@end
