//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxViewController.h"

@interface BeatBoxViewController ()

@property (nonatomic) IBOutlet UILabel *fileName;
@property (nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) IBOutlet UIButton *recButton;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property BOOL isRecording;

@end

@implementation BeatBoxViewController

@synthesize playButton      = _playButton;
@synthesize recButton       = _recButton;
@synthesize audioPlayer     = _audioPlayer;
@synthesize isRecording     = _isRecording;
@synthesize audioRecorder   = _audioRecorder;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)awakeFromNib
{
    
}

-(IBAction)recordButtonPushed:(UIButton *)sender
{
    
    NSError *error = nil;
    NSString *pathAsString = [self audioRecordingPath];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
    if (self.audioRecorder != nil){
        
        self.audioRecorder.delegate = self;
        
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]){
            NSLog(@"Successfully started to record.");
            
            [self.recButton setTitle:@"RECORDING" forState:UIControlStateNormal];
            
            /* After 5 seconds, let's stop the recording process */
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder afterDelay:5.0f];
        } else {
            NSLog(@"Failed to record.");
            self.audioRecorder = nil; }
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


-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
//	[self updateViewForPlayerState:p];
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

- (void) stopRecordingOnAudioRecorder :(AVAudioRecorder *)paramRecorder {
    [paramRecorder stop];

    // resetting Record button title
    [self.recButton setTitle:@"REC" forState:UIControlStateNormal];
}

@end

