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

// OUTLETS
@property (strong,nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) IBOutlet UIButton *recButton;
@property (strong, nonatomic) IBOutlet UILabel *recordProgressLabel;

// NON-VIEW
@property (strong, nonatomic) AVAudioPlayer     *audioPlayer;
@property (strong, nonatomic) AVAudioRecorder   *audioRecorder;
@property (strong, nonatomic) NSTimer           *playTimer;

// TODO: dictionary of sound names to sound objects
@property (strong, nonatomic) NSMutableDictionary *soundNameToRowDic;

// TODO: global tempo (beats per min) and global volume
@property NSInteger tempo;
@property NSInteger volume;
@property NSInteger globalCount;

@property NSInteger counterSecond;
@property (strong, nonatomic) NSString* recordedFileName;
@property (strong, nonatomic) NSString* soundDirectoryPath;

@property BOOL isRecording;

@end

@implementation BeatBoxViewController

@synthesize playButton          = _playButton;
@synthesize recButton           = _recButton;
@synthesize audioPlayer         = _audioPlayer;
@synthesize isRecording         = _isRecording;
@synthesize isPlaying           = _isPlaying;
@synthesize audioRecorder       = _audioRecorder;
@synthesize recordProgressLabel = _recordProgressLabel;
@synthesize counterSecond       = _counterSecond;
@synthesize recordedFileName    = _recordedFileName;
@synthesize soundNameToRowDic   = _soundNameToRowDic;
@synthesize globalCount         = _globalCount;


// Getter
- (NSString*)soundDirectoryPath {
    if (!_soundDirectoryPath) {

        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES);
        _soundDirectoryPath = [folders objectAtIndex:0];
    }
    return _soundDirectoryPath;
}


/**
 * viewDidLoad:
 * set the recordProgressLabel text to empty string.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // TODO: Initialize DrumMachine with the stored settings

    // creates the "sound" folder if not yet created
    self.soundDirectoryPath = [BeatBoxViewController createSoundFolder];
    
    // get all the sound files 
    NSArray *soundFilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.soundDirectoryPath  error:nil];
    
    // initialize the dictionary with SoundRow objects
    for (NSString* soundFilePath in soundFilePathsArray) {

        BeatBoxSoundRow *soundRow = [[BeatBoxSoundRow alloc] initWithPath:soundFilePath];
        
        [self.soundNameToRowDic setObject:soundRow forKey: soundRow.soundName];
    }
    
    self.recordProgressLabel.text = @"";
}

/**
 * viewDidUnload:
 *  Stop recording if we are.
 *  Set the audioRecorder to nil
 *  Stop the player if we're playing.
 */
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

/**
 * awakeFromNib:
 */
- (void)awakeFromNib {
    
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



/***************************************************************************
 ***** METHODS FOR PLAYING MUSIC
 ***************************************************************************/
- (void)play{
    NSLog(@">> Beginning play (recursive) loop!");
    
    // Create and initialize the timer.
    self.playTimer = [[NSTimer alloc] init];
    
    // Set the global counter to 0
    self.globalCount = 0;
    
    // set playing to YES
    self.isPlaying = YES;
    
    // Call the timer fire method for the firt time.
    [self.playTimer performSelector:@selector(timerFireMethod:)
                         withObject:self.playTimer
                         afterDelay:0];
}
   
 /*
 Gets called every time the timer is fired.
 Typically called every 16th note.
 */
- (void)timerFireMethod:(NSTimer *)timer {
    NSLog(@">>> TimerFireMethod called on count: %d for beat: %d", self.globalCount, self.globalCount % 16);
    
    // Get the global count. (0-15)
    int countForSound;
    
    // If we are playing
    if (self.isPlaying) {
        // ...for each sound
        for (BeatBoxSoundRow* sound in [self.soundNameToRowDic allValues]) {
            countForSound = self.globalCount % sound.notesPerMeasure;
            // ...if the bit is on.
            // [NOTE: can multiply by a multiplier if playing 8th or quarter notes instead]
            if ([sound.sixteenthNoteArray objectAtIndex:countForSound] != 0) {
                NSLog(@"Note is ON for sound at: %@", sound);
                // ...play the sound
                
                // Create an AVAudioPlayer with that sound
                AVAudioPlayer* player = [self createAudioPlayerWithSound:sound];
                
                // Prepare to play and play the sound
                [self playPlaybackForPlayer:player];
            } else
            {
                NSLog(@"Note is OFF for sound at: %@", sound);
            }
        }
        
        // Then do it again!!
        NSLog(@">>> Enqueuing timerFireMethod again!");
        self.globalCount++;
        [timer performSelector:@selector(timerFireMethod:)
                    withObject:timer
                    afterDelay:[self bpmToSixteenth]];
    }
}

- (int)bpmToSixteenth{
    // Calc 16th milliseconds from what bpm points to.
    return ((60000 / self.tempo) / 16);
}


- (void)stop {
    NSLog(@"Stopping playback");
    // Set self.isPlaying to NO
    self.isPlaying = NO;
    
    // Invalidate the timer
    [self.playTimer invalidate];
    
    // Reset count to 0;
    self.globalCount = 0;
}

// PLAY ALL 16TH NOTES THAT ARE ON FOR THIS SOUND ROW
/*
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
 */


//
-(void)recordSoundWithName:(NSString*)name
{    
    NSError *error = nil;
    NSString *pathAsString = [self.soundDirectoryPath stringByAppendingString:name];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]){
            NSLog(@"Successfully started to record in %@", audioRecordingURL);
            
            [self.recButton setTitle:@"Recording" forState:UIControlStateNormal];
            
            /* After 1 second, let's stop the recording process */
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder afterDelay:1.0f];
            
            //self.recordedFileName = name;
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
    NSLog(@"Play button pushed!");
    
    [self play];
    
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
    /*/
    NSString* testName = self.recordedFileName; //@"testSound.m4a";
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

// This gets called when a button on UIAlert view is clicked by user
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"OK"]) {

        NSLog(@"User pressed the OK button, start recording the sound...");
        
        // CHECK FOR EMPTY STRING
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

- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder {
    
    [paramRecorder stop];
    
    // TODO: save the recorded file
    BeatBoxSoundRow *recordedSond = [[BeatBoxSoundRow alloc] initWithUrl:paramRecorder.url];
    
    [self.soundNameToRowDic setObject:recordedSond forKey:recordedSond.soundName];
    
    // resetting Record button title
    [self.recButton setTitle:@"REC" forState:UIControlStateNormal];
}

-(void)countLabel:(NSTimer*)timer {
    
    if (self.counterSecond > 0) {
        self.recordProgressLabel.text = [NSString stringWithFormat:@"%d", self.counterSecond--];

    } else {
    
        [timer invalidate];
        self.recordProgressLabel.text = @"Go!";
        [self recordSoundWithName:self.recordedFileName];
        
    }
}

- (void)startRecording:(NSString*)soundName {
    
    self.recordedFileName = soundName;

    self.counterSecond = 3;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countLabel:) userInfo:nil repeats:YES];
    
    //NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countLabel:counterSecond) userInfo:nil repeats:YES];
}

- (IBAction)noteButtonPushed:(UIButton *)sender {

    // Get the sound associated with the button.
    UIView *row = [sender superview];
    NSString *soundName;
    
    // find the UILabel in the parent view (sound's view)
    for (id subview in row.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            soundName = [subview text];
            break;
        }
    }
    
    NSLog(@"sound: %@", soundName);

    /* 
     * Initialize soundNameToRowDic with the sounds available
     */
    BeatBoxSoundRow* soundRow = [self.soundNameToRowDic valueForKey:soundName];

    // toggle the 16th note associated with the noteButton
    [BeatBoxViewController toggleNoteArray:soundRow.sixteenthNoteArray
                                   atIndex:[sender.titleLabel.text intValue]];
}

+ (void)toggleNoteArray:(NSMutableArray*)noteArray atIndex:(NSUInteger)index {
    
    bool updatedNoteValue = YES;
    if ([[noteArray objectAtIndex:index] boolValue] == YES)
        updatedNoteValue = NO;
    
    [noteArray setObject:[NSNumber numberWithBool:updatedNoteValue] atIndexedSubscript:index];
}

// create sound folder for this device
+ (NSString*)createSoundFolder {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"sounds"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];

    return dataPath;
}

@end

