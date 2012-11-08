//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxViewController.h"

@interface BeatBoxViewController ()

@property (strong,nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) IBOutlet UIButton *recButton;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) IBOutlet UILabel *recordProgressLabel;
@property NSInteger counterSecond;

@property BOOL isRecording;

@end

@implementation BeatBoxViewController

@synthesize playButton      = _playButton;
@synthesize recButton       = _recButton;
@synthesize audioPlayer     = _audioPlayer;
@synthesize isRecording     = _isRecording;
@synthesize audioRecorder   = _audioRecorder;
@synthesize recordProgressLabel = _recordProgressLabel;
@synthesize counterSecond = _counterSecond;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.recordProgressLabel.text = @"";
}

- (void) viewDidUnload{ [super viewDidUnload];
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    
    self.audioRecorder = nil;
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    
    self.audioPlayer = nil;
}

- (void)awakeFromNib {
    
}

-(void)recordSound {
    
    NSError *error = nil;
    NSString *pathAsString = [self audioRecordingPath];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
    if (self.audioRecorder != nil){
        
        self.audioRecorder.delegate = self;
        
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]){
            NSLog(@"Successfully started to record.");
            
            [self.recButton setTitle:@"Recording" forState:UIControlStateNormal];
            
            /* After 5 seconds, let's stop the recording process */
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder afterDelay:5.0f];
        } else {
            NSLog(@"Failed to record.");
            self.audioRecorder = nil;
        }
    } else {
        NSLog(@"Failed to create an instance of the audio recorder.");
    }
}

- (IBAction)playButtonPushed:(UIButton *)sender
{
    NSLog(@"Successfully stopped the audio recording process.");
    
    /* Let's try to retrieve the data for the recorded file */
    NSError *playbackError = nil;
    NSError *readingError = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:[self audioRecordingPath] options:NSDataReadingMapped error:&readingError];
    
    /* Form an audio player and make it play the recorded data */
    self.audioPlayer =
    [[AVAudioPlayer alloc] initWithData:fileData error:&playbackError];
    
    /* Could we instantiate the audio player? */
    if (self.audioPlayer != nil){
        
        self.audioPlayer.delegate = self;
        
        /* Prepare to play and start playing */
        if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
            NSLog(@"Started playing the recorded audio.");
        } else {
            NSLog(@"Could not play the audio.");
        }
    } else {
        NSLog(@"Failed to create an audio player.");
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"OK"]) {

        NSLog(@"User pressed the OK button, start recording the sound...");
        
        [self startRecording:[[alertView textFieldAtIndex:0] text]];
        
    } else if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"User pressed the Cancel button.");
    }
}

- (IBAction)addNewSound {

    UIAlertView *alertView = [[UIAlertView alloc]
                                initWithTitle:@"File Name"
                                message:@"Please enter a name for this sound:"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"OK", nil];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alertView show];
}

- (NSString *) audioRecordingPath {

    NSString *result = nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:@"Recording.m4a"];
    return result;
}


- (NSDictionary *) audioRecordingSettings {
    
    NSDictionary *result = nil;
    
    /* Let's prepare the audio recorder options in the dictionary. Later we will use this dictionary to instantiate an audio recorder of type AVAudioRecorder */
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    [settings
     setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
    
    [settings
     setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
    
    [settings
     setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    
    [settings
     setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:settings];
    
    return result;
}

- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder {
    
    [paramRecorder stop];

    // resetting Record button title
    [self.recButton setTitle:@"REC" forState:UIControlStateNormal];
}

-(void)countLabel:(NSTimer*)timer {
    
    if (self.counterSecond > 0) {
        self.recordProgressLabel.text = [NSString stringWithFormat:@"%d", self.counterSecond--];

    } else {
    
        [timer invalidate];
        self.recordProgressLabel.text = @"Go!";
        [self recordSound];
        
    }
}

- (void)startRecording:(NSString*)soundName {
    
    self.counterSecond = 3;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countLabel:) userInfo:nil repeats:YES];
    
    //NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countLabel:counterSecond) userInfo:nil repeats:YES];
}

@end

