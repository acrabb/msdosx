//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxViewController.h"
#import "BeatBoxSoundRow.h"
#import "SoundRowView.h"



/***************************************************************************
 ***** BEGIN INTERNAL INTERFACE
 ***************************************************************************/
@interface BeatBoxViewController ()

// UI OUTLETS
@property (strong, nonatomic) IBOutlet UIButton     *playButton;
@property (strong, nonatomic) IBOutlet UIButton     *recButton;
@property (strong, nonatomic) IBOutlet UILabel      *recordProgressLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *soundFilePicker;

// NON-VIEW OBJECTS
@property (strong, nonatomic) AVAudioPlayer         *audioPlayer;
@property (strong, nonatomic) AVAudioRecorder       *audioRecorder;
@property (strong, nonatomic) NSTimer               *playTimer;
@property (strong, nonatomic) NSMutableDictionary   *soundNameToRowDic; // TODO
@property (strong, nonatomic) SoundRowView          *currentSoundView;
@property (strong, nonatomic) NSMutableArray        *alphabetizedFiles;

// OTHER VARS
@property NSInteger                                 tempo; // TODO
@property NSInteger                                 volume;
@property NSInteger                                 globalCount;
@property NSInteger                                 counterSecond;
@property (strong, nonatomic) NSString*             recordedFileName;
@property (strong, nonatomic) NSString*             soundDirectoryPath;
@property BOOL                                      isRecording;

@end





/***************************************************************************
 ***** BEGIN IMPLEMENATION
 ***************************************************************************/
@implementation BeatBoxViewController

// UI OBJECTS
@synthesize playButton          = _playButton;
@synthesize recButton           = _recButton;
@synthesize recordProgressLabel = _recordProgressLabel;
@synthesize soundFilePicker     = _soundFilePicker;
@synthesize pickerView          = _pickerView;

// NON-UI OBJECTS
@synthesize audioPlayer         = _audioPlayer;
@synthesize audioRecorder       = _audioRecorder;
@synthesize soundNameToRowDic   = _soundNameToRowDic;
@synthesize alphabetizedFiles   = _alphabetizedFiles;

// OTHER VARS
@synthesize isRecording         = _isRecording;
@synthesize isPlaying           = _isPlaying;
@synthesize counterSecond       = _counterSecond;
@synthesize recordedFileName    = _recordedFileName;
@synthesize globalCount         = _globalCount;






/***************************************************************************
 ***** METHODS FOR THE VIEW
 ***************************************************************************/

/**
 * viewDidLoad:
 * set the recordProgressLabel text to empty string.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Allocate space for the recorder and player.
    self.audioRecorder  = [AVAudioRecorder alloc];
    self.audioPlayer    = [AVAudioPlayer alloc];
    
    // TODO: Initialize DrumMachine with the stored settings
    /*
     Tempo
     Array of sounds
     isPlaying = NO
     isRecording = NO
     noteArray for each sound
     */
    
    // TODO: Set the tempo and tempo setter
    self.tempo = 100;
    
    /*** Fill dictionary with sounds from folder ***/
    [self fillDictionaryWithSounds];
    
    // Set the label to a default value.
    self.recordProgressLabel.text = @"Add new sound.";
    
    
    // Create and set the first soundRow
    SoundRowView *rowOne = [[SoundRowView alloc] initWithFrame:CGRectMake(0, 50, 480, 34)];
    [self.view addSubview:rowOne];
    
}

/*
    INITIALIZE DICTIONARY AND FILL IT WITH SOUNDS FROM 'SOUND' FOLDER
 */
- (void)fillDictionaryWithSounds {
    // creates the "sound" folder if not yet created
    self.soundDirectoryPath = [BeatBoxViewController createSoundFolder];
    
    // get all the sound files 
    NSArray *soundFilePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.soundDirectoryPath  error:nil];

    NSLog(@"getting all sound files from %@...", self.soundDirectoryPath);

    // initialize the dictionary with SoundRow objects
    for (NSString* soundFilePath in soundFilePathsArray) {
        BeatBoxSoundRow *soundRow = [[BeatBoxSoundRow alloc] initWithPath:soundFilePath];
        NSLog(@"Adding SoundRow object to dictionary\n\tname: %@\tsoundPath: %@", soundRow.soundName, soundRow.soundFilePath);
        if (!self.soundNameToRowDic) {
            NSLog(@"dic is nil!");
        }
        [self.soundNameToRowDic setObject:soundRow forKey: soundRow.soundName];
        
        NSLog(@"added dictionary, new dic size: %d", self.soundNameToRowDic.count);
        NSLog(@"full path: %@", [self getFullPathForSoundRow:soundRow]);
    }
}


/**
 * viewDidUnload:
 *  Stop recording if we are.
 *  Set the audioRecorder to nil
 *  Stop the player if we're playing.
 */
- (void) viewDidUnload {
    [super viewDidUnload];
    // Stop recording if we are
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    self.audioRecorder = nil;
    
    // Stop playback if we are.
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

/*
    This gets called when a button on UIAlert view is clicked by user
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"OK"]) {
        NSLog(@"User pressed the OK button, start recording the sound...");
        // TODO: CHECK FOR EMPTY STRING
        [self startRecording:[[alertView textFieldAtIndex:0] text]];
    } else if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"User pressed the Cancel button.");
    }
}


/*** CODE FOR THE FILE PICKER ***/

// Puts the subview IN view.
- (IBAction)soundNameButtonPushed:(UIButton *)sender {
    NSLog(@"soundNameButtonPushed!");
    // Display sound file picker.self.soundFilePicker.dataSource = self;
    self.soundFilePicker.delegate = self;
    self.soundFilePicker.showsSelectionIndicator = YES;
    [UIView beginAnimations:nil context:NULL];
    [self.pickerView setFrame:CGRectMake(0.0f, 0.0f, 480.0f, 300.0f)];
    [UIView commitAnimations];
    
    // Get the superview, and set it as the current sound row
    self.currentSoundView = (SoundRowView*)[sender superview];
    [self.currentSoundView setBackgroundColor:[UIColor redColor]];
    NSLog(@"At end of SNBP method!");
}

/*
    Set the number of columns to one.
 */
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger result = 0;
    if ([pickerView isEqual:self.soundFilePicker]) {
        result = 1;
    }
    return result;
}
/*
    Set the number of rows to the number of saved files + 1.
        (One extra for the "New file" row.)
 */
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger result = 0;
    if ([pickerView isEqual:self.soundFilePicker]) {
        result = [self.soundNameToRowDic count] + 1;
    }
    return result;
}
- (NSString*) pickerView:(UIPickerView *) pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSString* result = nil;
    if ([pickerView isEqual:self.soundFilePicker]) {
        // Fill the rows
        NSLog(@">>> Filling on row: %d", row);
        // If row == 0, can add new file.
        if (row == 0) {
            // add new file
            return @"New File...";
        }
        // else, be name of sound file in dict at row -1
        [self alphabetizeFiles];
        return [self.alphabetizedFiles objectAtIndex:(row - 1)];
    }
    return nil;
}

/*
    Alphabetizes an array of currently saved files.
 */
- (void)alphabetizeFiles {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                ascending:YES];
    NSArray* arr = [self.soundNameToRowDic allKeys];
    self.alphabetizedFiles = [arr mutableCopy];
    [self.alphabetizedFiles sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
}

// Puts the subview OUT of view.
- (IBAction)pickerButtonPushed {
    [UIView beginAnimations:nil context:NULL];
    [self.pickerView setFrame:CGRectMake(0.0f, 300.0f, 480.0f, 300.0f)];
    [UIView commitAnimations];
    int index = [self.soundFilePicker selectedRowInComponent:0];
    // On sound selection
    // Either record new sound file.
    if (index == 0) {
        [self addNewSound];
    } else {
        // Or set current view to selected sound and add sound to sounds array.
        NSString* selection = [self.alphabetizedFiles objectAtIndex:(index-1)];
        self.currentSoundView.sound = [self.soundNameToRowDic valueForKey:selection];
        // TODO Add to current sounds.
        [self.currentSoundView updateButtons];
    }
    
}








/***************************************************************************
 ***** METHODS FOR PLAYING MUSIC
 ***************************************************************************/
/*
    User pushed the play button.
 */
- (IBAction)playButtonPushed:(UIButton *)sender
{
    NSLog(@"Play button pushed!");
    
    // If not playing:
    //  Set PLAY button to STOP button
    if (!self.isPlaying) {
        //  Start playback
        self.isPlaying = YES;
        [self play];
        [self.playButton.titleLabel setText:@"Stop"];
    } else {
        self.isPlaying = NO;
        [self.playButton.titleLabel setText:@"Play"];
        [self stop];
    }
    
}
/*
    START PLAYBACK FOR THE SPECIFIED AUDIOPLAYER
 */
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player {
    if (player != nil){
        player.delegate = self;
        NSLog(@">>> About to play player: %@", player);
        if ([player prepareToPlay] && [player play]){
            NSLog(@"Started playing the recorded audio.");
        } else {
            NSLog(@"Could not play the audio :(");
        }
    } else {
        NSLog(@"nil AVAudioPlayer received :(");
    }
}

/*
    START THE PLAYBACK LOOP
 */
- (void)play {
    NSLog(@">> Beginning play (recursive) loop!");
        
    // Set the global counter to 0
    self.globalCount = 0;
    
    ////////////////// Temp hack to play
    int countForSound;
    for (int i=0; i<16; i++) {
        // If we are playing
        if (self.isPlaying) {
            NSLog(@">>> >>> We are playing...");
            NSLog(@">>> >>> Sounds in dictionary: %d", self.soundNameToRowDic.count);
            // ...for each sound
            for (BeatBoxSoundRow* sound in [self.soundNameToRowDic allValues]) {
                countForSound = i;
                NSLog(@">>> >>> Sound: %@", sound);
                NSLog(@">>> >>> Sound array: %@", sound.sixteenthNoteArray);
                // ...if the bit is on.
                // [NOTE: can multiply by a multiplier if playing 8th or quarter notes instead]
                BOOL isOn = [[sound.sixteenthNoteArray objectAtIndex:countForSound] boolValue];
                if (isOn) {
                    NSLog(@"Note is ON for sound at: %d", i);
                    NSLog(@"Element at i: %@", [sound.sixteenthNoteArray objectAtIndex:countForSound]);
                    // ...play the sound
                    
                    // Create an AVAudioPlayer with that sound
                    AVAudioPlayer* player = [self createAudioPlayerWithSound:sound];
                    
                    NSLog(@">>> >>> About to play file: %@", [self getFullPathForSoundRow:sound]);
                    // Prepare to play and play the sound
                    [self playPlaybackForPlayer:player];
                } else
                {
                    NSLog(@"Note is OFF for sound at: %@", sound);
                }
            }
            [NSThread sleepUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:(.001 *[self bpmToSixteenth])]];
        }
    }
    //\\\\\\\\\\\\\\\\ End temp hack to play
    
    
    // Call the timer fire method for the firt time.
//    [self performSelector:@selector(timerFireMethod)
//                         withObject:nil
//                         afterDelay:0];

    // Create and initialize the timer.
//    self.playTimer = [NSTimer timerWithTimeInterval:1
//                                             target:self
//                                           selector:@selector(timerFireMethod:)
//                                           userInfo:nil
//                                            repeats:NO];
    NSLog(@">> >> Timer created: %@", self.playTimer.description);
    NSLog(@">> Loop should be playing.");
}
   
 /*
    Gets called every time the timer is fired.
    Typically called every 16th note.
 */
- (void)timerFireMethod {
    NSLog(@">>> TimerFireMethod called on count: %d for beat: %d", self.globalCount, self.globalCount % 16);
    NSLog(@">>> >>> Received object: %@", nil);
    
    // Get the global count. (0-15)
    int countForSound;
    
    // If we are playing
    if (self.isPlaying) {
        NSLog(@">>> >>> We are playing...");
        NSLog(@">>> >>> Sounds in dictionary: %d", self.soundNameToRowDic.count);
        // ...for each sound
        for (BeatBoxSoundRow* sound in [self.soundNameToRowDic allValues]) {
            countForSound = self.globalCount % sound.notesPerMeasure;
            NSLog(@">>> >>> Sound: %@", sound);
            // ...if the bit is on.
            // [NOTE: can multiply by a multiplier if playing 8th or quarter notes instead]
            if ([sound.sixteenthNoteArray objectAtIndex:countForSound] != 0) {
                NSLog(@"Note is ON for sound at: %@", sound);
                // ...play the sound
                
                // Create an AVAudioPlayer with that sound
                AVAudioPlayer* player = [self createAudioPlayerWithSound:sound];
                
                NSLog(@">>> >>> About to play file: %@", [self getFullPathForSoundRow:sound]);
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
        [self performSelector:@selector(timerFireMethod)
                    withObject:nil
                    afterDelay:[self bpmToSixteenth]];
    }
}


- (int)bpmToSixteenth{
    // Calc 16th milliseconds from what bpm points to.
    return ((60000 / self.tempo) / 16);
}






/***************************************************************************
 ***** METHODS FOR STOPPING PLAYBACK
 ***************************************************************************/
- (void)stop {
    NSLog(@"Stopping playback");
    // Set self.isPlaying to NO
    self.isPlaying = NO;
    
    // Invalidate the timer
    [self.playTimer invalidate];
    
    // Reset count to 0;
    self.globalCount = 0;
}





/***************************************************************************
 ***** METHODS FOR RECORDING SOUNDS
 ***************************************************************************/
/*
    Start the timer to count down.
 */
- (void)startRecording:(NSString*)soundName {
    self.recordedFileName = soundName;
    self.counterSecond = 3;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countLabel:) userInfo:nil repeats:YES];
}
/*
    Called by the timer to countdown to recording.
 */
-(void)countLabel:(NSTimer*)timer {
    if (self.counterSecond > 0) {
        self.recordProgressLabel.text = [NSString stringWithFormat:@"%d", self.counterSecond--];
    } else {
        [timer invalidate];
        self.recordProgressLabel.text = @"Go!";
        [self recordSoundWithName:self.recordedFileName];
        
    }
}

-(void)recordSoundWithName:(NSString*)name
{
    // Recordig settings.
    NSError *error = nil;
    NSString *pathAsString = [self.soundDirectoryPath stringByAppendingString:[name stringByAppendingString:@".m4a"]];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    // Initialize the recorder.
    self.audioRecorder = [self.audioRecorder initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
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


// INIT THE AUDIOPLAYER WITH THE FILEPATH FOR THE SPECIFIED SOUND
- (AVAudioPlayer*)createAudioPlayerWithSound:(BeatBoxSoundRow*) sound {
    if (sound == nil) {
        NSLog(@"!!! Nil sound received for player! :(");
    }
    NSData *fileData = [NSData dataWithContentsOfFile:[self getFullPathForSoundRow:sound]
                                              options:NSDataReadingMapped
                                                error:nil];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    
    return player;
}

/*
// CREATE A FILE PATH WITH THE GIVEN SOUND NAME
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
*/


- (NSDictionary *) audioRecordingSettings {
    NSDictionary *result = nil;
    
    /* Let's prepare the audio recorder options in the dictionary.
        Later we will use this dictionary to instantiate an audio
        recorder of type AVAudioRecorder
     */
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless]
                forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0f]
                forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInteger:1]
                forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow]
                forKey:AVEncoderAudioQualityKey];
    result = [NSDictionary dictionaryWithDictionary:settings];
    return result;
}


- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder {
    
    [paramRecorder stop];
    
    NSLog(@"url: %@",paramRecorder.url.lastPathComponent);
    
    // TODO: save the recorded file
    BeatBoxSoundRow *recordedSound = [[BeatBoxSoundRow alloc] initWithPath:paramRecorder.url.lastPathComponent];
    
    NSLog(@"sound file stored: %@ \n\tin %@", recordedSound.soundName, recordedSound.soundFilePath);
    
    [self.soundNameToRowDic setObject:recordedSound forKey:recordedSound.soundName];
    
    for (NSString* key in [self.soundNameToRowDic allKeys])
        NSLog(@"key: %@\tvalue: %@", key, [self.soundNameToRowDic objectForKey:key]);
    
    // resetting Record button title
    [self.recButton setTitle:@"REC" forState:UIControlStateNormal];
}





/***************************************************************************
 ***** MISC METHODS
 ***************************************************************************/
// Getter
- (NSString*)soundDirectoryPath {
    if (!_soundDirectoryPath) {

        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES);
        _soundDirectoryPath = [folders objectAtIndex:0];
    }
    return _soundDirectoryPath;
}

- (NSMutableDictionary*)soundNameToRowDic {
    if (!_soundNameToRowDic) {
        _soundNameToRowDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return _soundNameToRowDic;
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

    [sender setImage:[UIImage imageNamed:@"note_button_pushed.png"] forState:UIControlStateHighlighted];
    
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


- (NSString*)getFullPathForSoundRow:(BeatBoxSoundRow *)soundRow {
    return [self.soundDirectoryPath stringByAppendingString:soundRow.soundFilePath];
}


// create sound folder for this device
+ (NSString*)createSoundFolder {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"sounds"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];

    return [dataPath stringByAppendingString:@"/"];
}

@end

