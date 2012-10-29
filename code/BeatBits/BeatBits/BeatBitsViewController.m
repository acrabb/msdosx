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
//@interface BeatBitsViewController ()
//
//@end

@implementation BeatBitsViewController

@synthesize recordButton = _recordButton;
@synthesize playButton = _playButton;
@synthesize isRecording = _isRecording;
@synthesize recordStateLabel = _recordStateLabel;



- (IBAction)recording:(id)sender
{
    if(!_isRecording)
    {
        _isRecording = YES;
        [_recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        _playButton.hidden = YES;
        _recordStateLabel.text = @"Recording";
        
        tempRecordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"file001"]];
        recorder = [[AVAudioRecorder alloc] initWithURL:tempRecordedFile settings:nil error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    }
    else
    {
        _isRecording = YES;
        [_recordButton setTitle:@"REC" forState:UIControlStateNormal];
        _playButton.hidden = NO;
        _recordStateLabel.text = @"Not Recording";
        
        [recorder stop];
    }
}

- (IBAction)playback:(id)sender
{
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:tempRecordedFile error:nil];
    player.volume = 1;
    [player play];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _isRecording = false;
    _playButton.hidden = YES;
    _recordStateLabel.text = @"Not Recording";
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)viewDidUnload
{
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:tempRecordedFile error:nil];
    recorder = nil;
    tempRecordedFile = nil;
    _playButton.hidden = YES;
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
