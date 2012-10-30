//
//  BeatBitsViewController.m
//  BeatBits
//
//  Created by Amir Khodaei on 10/22/12.
//
//

#import "BeatBitsViewController.h"
#import <AVFoundation/AVFoundation.h>

// IS THIS NEEDED? What is it for?
@interface BeatBitsViewController ()

@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) NSURL *tempRecordedFile;
@property(nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BeatBitsViewController

@synthesize recordButton = _recordButton;
@synthesize playButton = _playButton;
@synthesize isRecording = _isRecording;
@synthesize recordStateLabel = _recordStateLabel;
@synthesize recorder = _recorder;
@synthesize tempRecordedFile = _tempRecordedFile;
@synthesize player = _player;


- (IBAction)recording:(id)sender
{
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        self.playButton.hidden = YES;
        self.recordStateLabel.text = @"Recording";

        
        self.tempRecordedFile = [NSURL fileURLWithPath:@"soundfiles/temp001"];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.tempRecordedFile settings:nil error:nil];
        self.recorder.delegate = self;
        [self.recorder prepareToRecord];
        [self.recorder record];
        NSLog(@"ACACAC Recording! Temp file: %@", self.tempRecordedFile);
    }
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        self.playButton.hidden = NO;
        self.recordStateLabel.text = @"Not Recording";
        
        [self.recorder stop];
    }
}

- (IBAction)playback:(id)sender
{
    NSLog(@"in playback");
    
    //self.tempRecordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"file001"]];
    self.tempRecordedFile = [NSURL fileURLWithPath:@"electronics001.wav"];
    
    NSString *tempFile = [[NSBundle mainBundle] pathForResource:@"electronics001" ofType:@"wav"];
    NSURL *tempURL = [[NSURL alloc] initFileURLWithPath:tempFile];
    
//    NSData *soundFile = [[NSData alloc] initWithContentsOfFile:@"soundfiles/electronics001.wav"];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:tempURL error:nil];
    
    NSLog(@"player obj: %@", [player description]);
    
    player.volume = 1.0;
    
    [player play];
    
    NSLog(@"after player is played!: URL: %@", tempURL);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.isRecording = false;
    self.playButton.hidden = NO;
    self.recordStateLabel.text = @"Not Recording";
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)viewDidUnload
{
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:[self.tempRecordedFile description] error:nil];
//    self.recorder = nil;
//    self.tempRecordedFile = nil;
    self.playButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)dealloc {
//    [_recordButton release];
//    [_playButton release];
//    [super dealloc];
//}

@end
