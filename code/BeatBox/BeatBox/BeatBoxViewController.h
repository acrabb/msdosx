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
#import "SoundRowView.h"

@interface BeatBoxViewController : UIViewController
<AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate>

@property BOOL isPlaying;
@property (strong, nonatomic) IBOutlet UIView *pickerView;

- (void)recordSoundWithName:(NSString*)name;

- (IBAction)pickerButtonPushed;

- (IBAction)playButtonPushed:(UIButton *)sender;

- (IBAction)addNewSound;

- (NSString*)audioFilePath;
- (NSString*)audioFilePathWithName:(NSString*) name;

- (NSDictionary*)audioRecordingSettings;
- (void)startRecording:(NSString*)soundName;

- (IBAction)soundNameButtonPushed:(UIButton *)sender;

// soundFilePicker methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString*) pickerView:(UIPickerView *) pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component;

// Added by Andre.
- (void)recordSoundForFile:(NSString*) newFileName;
- (void)playMeasureForSound:(BeatBoxSoundRow*) sound;
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player;
- (void)recordWithName:(NSString*) name;
- (void)createNewSound;
- (IBAction)noteButtonPushed:(UIButton *)sender;
+ (void)toggleNoteArray:(NSMutableArray*)noteArray atIndex:(NSUInteger)index;

@end
