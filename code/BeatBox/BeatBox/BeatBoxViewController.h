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
<AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate>

- (void)recordSound;

- (IBAction)playButtonPushed:(UIButton *)sender;

- (IBAction)addNewSound;

- (NSString*)audioRecordingPath;
- (NSDictionary*)audioRecordingSettings;
- (void)startRecording:(NSString*)soundName;

@end
