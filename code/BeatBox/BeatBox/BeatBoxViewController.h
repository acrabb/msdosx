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
<AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate>

- (void)recordSoundWithName:(NSString*)name;

- (IBAction)playButtonPushed:(UIButton *)sender;

- (IBAction)addNewSound;

- (NSString*)audioFilePath;
- (NSString*)audioFilePathWithName:(NSString*) name;

- (NSDictionary*)audioRecordingSettings;
- (void)startRecording:(NSString*)soundName;


// Added by Andre.
- (void)recordSoundForFile:(NSString*) newFileName;
- (void)playMeasureForSound:(BeatBoxSoundRow*) sound;
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player;
- (void)recordWithName:(NSString*) name;
- (void) createNewSound;

@end
