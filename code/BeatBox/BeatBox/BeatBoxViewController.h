//
//  BeatBoxViewController.h
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BeatBoxSoundRow.h"

@interface BeatBoxViewController : UIViewController
<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

- (IBAction)recordButtonPushed:(UIButton*) sender;
- (IBAction)playButtonPushed:(UIButton*) sender;

- (NSString*)audioFilePath;
- (NSString*)audioFilePathWithName:(NSString*) name;
- (NSDictionary*)audioRecordingSettings;


// Added by Andre.
- (void)recordSoundForFile:(NSString*) newFileName;
- (void)playMeasureForSound:(BeatBoxSoundRow*) sound;
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player;
- (void)recordWithName:(NSString*) name;


@end
