//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxViewController.h"
#import "BeatBoxSoundRow.h"

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




- (void) createNewSound {
    //record new or choose existing file
    
    // if record new...
    // show askUserForNewSoundName popup and get new name.
    NSString* soundName = @"sound1";
    // save the file in some directory with newSoundName
    
    // create a new SoundRow object with the newSoundName and path, and an empty bit array.
    BeatBoxSoundRow* row = [[BeatBoxSoundRow alloc] initWithName:soundName array:[[NSMutableArray alloc] initWithCapacity:16] volume:1.0 filePath:self.audioFilePath];
    
    // populate the view to show this new row
    // [move the "create new sound" soundRow below the newly created row]
    
}

// PLAY ALL 16TH NOTES THAT ARE ON FOR THIS SOUND ROW
- (void)playMeasureForSound:(BeatBoxSoundRow *)sound {
    NSLog(@"ACACAC Beginning playing measure for sound %@", sound.soundName);
    
    for (int i=0; i<16; i++) {
        NSLog(@"ACACAC At note %d for sound %@", i, sound.soundName);
        if ([sound.sixteenthNoteArray objectAtIndex:i] != 0) {
            self.audioPlayer = [self createAudioPlayerWithSound:sound];
            [self playPlaybackForPlayer:self.audioPlayer];
            
            // TEMPORARILY WAIT FOR 1 SECOND BETWEEN 16TH NOTES
            NSLog(@"ACACAC Waiting for 1000 ms");
            [NSThread sleepUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        }
    }
}


-(IBAction)recordButtonPushed:(UIButton *)sender {
    NSString* name = @"testSound.m4a";
    [self recordWithName:name];
}

-(void)recordWithName:(NSString*) name
{
    
    NSError *error = nil;
    NSString *pathAsString = [self audioFilePathWithName:name];
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
                       withObject:self.audioRecorder afterDelay:1.0f];
        } else {
            NSLog(@"Failed to record.");
            self.audioRecorder = nil; }
    } else {
        NSLog(@"Failed to create an instance of the audio recorder.");
    }
}

- (IBAction)playButtonPushed:(UIButton *)sender
{
    NSLog(@"Play button pushed!");
    
    /*/
    // Let's try to retrieve the data for the recorded file
    NSError *playbackError = nil;
    NSError *readingError = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:[self audioFilePath] options:NSDataReadingMapped error:&readingError];
    
    // Form an audio player and make it play the recorded data
    self.audioPlayer =
    [[AVAudioPlayer alloc] initWithData:fileData error:&playbackError];
    
    // Could we instantiate the audio player?
    [self playPlaybackForPlayer:self.audioPlayer];
    
    /**/
    
    // TEMPORARY TEST BY ANDRE TO PLAY A MEASURE OF THE RECORDED FILE
    /**/
    NSString* testName = @"testSound.m4a";
    NSLog(@"ACACAC Creating testArray.");
    NSMutableArray* testArray = [BeatBoxSoundRow defaultArray];
    NSLog(@"ACACAC Creating sound object.");
    BeatBoxSoundRow* oneSound = [[BeatBoxSoundRow alloc] initWithName:testName array:testArray volume:1.0 filePath: [self audioFilePathWithName:testName]];
    
    [self playMeasureForSound:oneSound];
    /**/
}


// INIT THE AUDIOPLAYER WITH THE FILEPATH FOR THE SPECIFIED SOUND
- (AVAudioPlayer*)createAudioPlayerWithSound:(BeatBoxSoundRow*) sound {
    NSData *fileData = [NSData dataWithContentsOfFile:[self audioFilePathWithName:sound.soundName] options:NSDataReadingMapped error:nil];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    
    return player;
}


// START PLAYBACK FOR THE SPECIFIED AUDIOPLAYER
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player {
    if (player != nil){
        player.delegate = self;
        
        /* Prepare to play and start playing */
        if ([player prepareToPlay] && [player play]){
            NSLog(@"Started playing the recorded audio.");
        } else {
            NSLog(@"Could not play the audio.");
        }
    } else {
        NSLog(@"nil AVAudioPlayer received.");
    }
}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
//	[self updateViewForPlayerState:p];
}


// CREATE A RECORDING PATH WITH THE GIVEN SOUND NAME
- (NSString *) audioFilePathWithName:(NSString *)name {

    NSString *result = nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:name];

    return result;
}

// CREATE A RECORDING PATH WITH A DEFAULT VALUE
- (NSString*) audioFilePath {
    return [self audioFilePathWithName:@"recording.m4a"];
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

