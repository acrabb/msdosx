//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxViewController.h"

@interface BeatBoxViewController ()

@end

@implementation BeatBoxViewController

@synthesize fileURL     = _fileURL;
@synthesize playButton  = _playButton;
@synthesize recButton   = _recButton;
@synthesize player      = _player;
@synthesize isRecording = _isRecording;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"ACACAC ViewDidLoad! :)");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"ACACAC DidReceiveMemoryWarning! :(");
}


- (void)awakeFromNib
{
//	playBtnBG = [[UIImage imageNamed:@"play.png"] retain];
//  pauseBtnBG = [UIImage imageNamed:@"pause.png"];
//	[playButton setImage:playBtnBG forState:UIControlStateNormal];
//  [self registerForBackgroundNotifications];
//	updateTimer = nil;
//	rewTimer = nil;
//	ffwTimer = nil;
//	duration.adjustsFontSizeToFitWidth = YES;
//	currentTime.adjustsFontSizeToFitWidth = YES;
//	progressBar.minimumValue = 0.0;
	
    NSLog(@"ACACAC AwokeFromNib! :)");
    
    self.isRecording = NO;
    
	// SET THE SAMPLE FILE URL, use mono or stero sample
	self.fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"]];
    
    
    //NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sample2ch" ofType:@"m4a"]];
    
    /*/
    // INITIALIZE THE PLAYER
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileURL error:nil];
  
	if (self.player)
	{
		self.fileName.text = [NSString stringWithFormat: @"%@ (%d ch.)", [[self.player.url relativePath] lastPathComponent], self.player.numberOfChannels, nil];
        
//		[self updateViewForPlayerInfo:self.player];
//		[self updateViewForPlayerState:self.player];
//		self.player.numberOfLoops = 1;
//		self.player.delegate = self;
	}
    */
    
    
    // INITIALIZE THE RECORDER WITH THE FILE URL
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:nil error:nil];
    

	// INITIALIZE THE AUDIO SESSION
	OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if (result)
		NSLog(@"Error initializing audio session! %ld", result);
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
	if (setCategoryError)
		NSLog(@"Error setting category! %@", setCategoryError);
    
	
//	result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
//	if (result)
//		NSLog(@"Could not add property listener! %ld", result);
	
//	[self.fileURL release];
}



-(IBAction)recordButtonPushed:(UIButton *)sender
{
    NSLog(@"ACACAC RecordButtenPushed");
    // fileURL
    if(!self.isRecording)
    {
        NSDictionary *recordSettings =
        [[NSDictionary alloc] initWithObjectsAndKeys:
         [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
         [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
         [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
         [NSNumber numberWithInt: AVAudioQualityMax],
         AVEncoderAudioQualityKey,
         nil];
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:recordSettings error:nil];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
        
        self.recButton.titleLabel.text = @"STOP";
        NSLog(@"ACACAC Recorder recording at file: %@", self.fileURL);
        self.isRecording = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
    } else
    {
        [self.recorder stop];
        self.isRecording = NO;
        NSLog(@"ACACAC Recorder STOPPED recording");
        self.recButton.titleLabel.text = @"REC";
        
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
        
        [self.player initWithContentsOfURL:self.fileURL error:nil];
        if (self.player)
        {
            self.fileName.text = [NSString stringWithFormat: @"%@ (%d ch.)", [[self.player.url relativePath] lastPathComponent], self.player.numberOfChannels, nil];
//            [self updateViewForPlayerInfo:self.player];
//            [self updateViewForPlayerState:self.player];
//            self.player.numberOfLoops = 1;
            self.player.delegate = self;
        }
        
        
    }
    
    
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
	if ([p play])
	{
//		[self updateViewForPlayerState:p];
        NSLog(@"ACACAC Player playing file: %@", self.fileURL);
	}
	else
    {
		NSLog(@"Could not play %@\n", p.url);
    }
}

- (IBAction)playButtonPushed:(UIButton *)sender
{
	if (self.player.playing == YES)
		[self pausePlaybackForPlayer: self.player];
	else
		[self startPlaybackForPlayer: self.player];
}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
//	[self updateViewForPlayerState:p];
}


//- (IBAction)playButtonPressed:(UIButton *)sender {
//}
@end

