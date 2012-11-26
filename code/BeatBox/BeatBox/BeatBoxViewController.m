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
#import "BeatBoxLightBulbView.h"


/***************************************************************************
 ***** BEGIN INTERNAL INTERFACE
 ***************************************************************************/
@interface BeatBoxViewController ()

// UI OUTLETS
@property (strong, nonatomic) IBOutlet UIButton     *playButton;
@property (strong, nonatomic) IBOutlet UILabel      *recordProgressLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *soundFilePicker;

@property (strong, nonatomic) SoundRowView          *currentSoundView;
@property (strong, nonatomic) NSMutableArray        *soundObjectsInView;
@property (strong, nonatomic) NSMutableArray        *soundRowViews;
@property (strong, nonatomic) NSMutableArray        *activatedSounds;

@property (strong, nonatomic) BeatBoxLightBulbView  *lightBulbView;

// NON-VIEW OBJECTS
@property (strong, nonatomic) AVAudioRecorder       *audioRecorder;
@property (strong, nonatomic) NSTimer               *playTimer;
@property (strong, nonatomic) NSMutableDictionary   *soundNameToRowDic; // TODO
@property (strong)            AVAudioPlayer         *player;
@property (strong, nonatomic) NSMutableArray        *alphabetizedFiles;

// OTHER VARS
@property NSInteger                                 tempo; // TODO
@property NSInteger                                 volume;
@property NSInteger                                 globalCount;
@property NSInteger                                 counterSecond;
@property (strong, nonatomic) NSString*             recordedFileName;
@property (strong, nonatomic) NSString*             soundDirectoryPath;
@property BOOL                                      isRecording;
@property (strong, nonatomic) NSTimer*              lightBulbTimer;
@property (strong, nonatomic) NSNumber*             currentLightBulb;

@end



/***************************************************************************
 ***** BEGIN IMPLEMENATION
 ***************************************************************************/
@implementation BeatBoxViewController

// UI OBJECTS
@synthesize playButton          = _playButton;
@synthesize recordProgressLabel = _recordProgressLabel;
@synthesize soundFilePicker     = _soundFilePicker;
@synthesize pickerView          = _pickerView;
@synthesize soundRowViews       = _soundRowViews;
@synthesize activatedSounds     = _activatedSounds;
@synthesize soundObjectsInView  = _soundObjectsInView;
@synthesize bpmNumberLabel      = _bpmNumberLabel;
@synthesize lightBulbView       = _lightBulbView;

// NON-UI OBJECTS
@synthesize audioRecorder       = _audioRecorder;
@synthesize soundNameToRowDic   = _soundNameToRowDic;
@synthesize alphabetizedFiles   = _alphabetizedFiles;
@synthesize player              = _player;

// OTHER VARS
@synthesize isRecording         = _isRecording;
@synthesize isPlaying           = _isPlaying;
@synthesize counterSecond       = _counterSecond;
@synthesize recordedFileName    = _recordedFileName;
@synthesize globalCount         = _globalCount;
@synthesize lightBulbTimer      = _lightBulbTimer;
@synthesize currentLightBulb    = _currentLightBulb;
NSString*   M4AEXTENSION        = @".m4a";

int nextRowXPos = 0; // Should never change.
int nextRowYPos = 0;
int ROW_HEIGHT  = 34;
int ROW_LENGTH  = 480;
int SPACE       = 2;

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
    
    // TODO: Initialize DrumMachine with the stored settings
    /*
     Tempo
     Array of sounds (array of soundRowView subviews)
     isPlaying = NO
     isRecording = NO
     noteArray for each sound
     */
    
    // TODO: Set the tempo and tempo setter
    self.tempo = 100;
    [self setBpmNumberLabelText:self.tempo];
    
    /*** Fill dictionary with sounds from folder ***/
    [self fillDictionaryWithSounds];
    
    // Set the label to a default value.
    self.recordProgressLabel.text = @"Add new sound";
    
    // add light bulb view
    BeatBoxLightBulbView *lightBulbView = [[BeatBoxLightBulbView alloc] initWithFrame:CGRectMake(0, 0, 480, 34) andController:self];
    [self.view addSubview:lightBulbView];
    self.lightBulbView = lightBulbView;
    
    /*
     * Initialize the rows with as many sounds as we can fit in
     * some of the sounds we
     */
    NSArray *soundKeys = [self.soundNameToRowDic allKeys];
    int height = 36;
    int numSoundViews = 0;
    
    for (NSString* soundName in soundKeys) {

        if (numSoundViews > 5)
            break;
        
        // create a new soundRowView for each sound if we have enough space
        SoundRowView *row = [[SoundRowView alloc] initWithFrame:CGRectMake(0, (numSoundViews + 1) * height, 480, 34) andController:self];
        [self.soundRowViews addObject:row];
        NSLog(@"soundRowView size = %d", self.soundRowViews.count);
        [self.view addSubview:row];
        
        BeatBoxSoundRow* soundObject = [self.soundNameToRowDic objectForKey:soundName];
        [self linkSound:soundObject withView:row];
        [self.soundObjectsInView addObject:soundObject];
        
        numSoundViews ++;
    }
    
    // TODO: Need to set the pickerView's layer to always be on top, regardless of add order.
    [self.view addSubview:self.pickerView];
    NSLog(@"soundObjectsInView size: %d", self.soundObjectsInView.count);
}

- (void)setLightBulbToGreenAt:(NSInteger)lightBulbIndex {
    UIImageView *lightBulb = (UIImageView*)[self.lightBulbView viewWithTag:lightBulbIndex + 1];
    [lightBulb setImage:[UIImage imageNamed:@"led-circle-green-md.png"]];
}

- (void)setLightBulbToRedAt:(NSInteger)lightBulbIndex {
    UIImageView *lightBulb = (UIImageView*)[self.lightBulbView viewWithTag:lightBulbIndex + 1];
    [lightBulb setImage:[UIImage imageNamed:@"led-circle-red-md.png"]];
}

- (void)setLightBulbToGreyAt:(NSInteger)lightBulbIndex {
    NSLog(@"turning %d to grey", lightBulbIndex + 1);
    UIImageView *lightBulb = (UIImageView*)[self.lightBulbView viewWithTag:lightBulbIndex + 1];
    [lightBulb setImage:[UIImage imageNamed:@"led-circle-grey-md.png"]];
}

- (void)startPlayingLightBulbsAtIndex:(int)index {
    
    self.currentLightBulb = [NSNumber numberWithInt:index];
    self.lightBulbTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playLightBulb) userInfo:nil repeats:YES];
    
}

- (void)stopPlayingLightBulbs {
    if (self.lightBulbTimer != nil) {
        [self setLightBulbToGreyAt:[self getPrevLightBulbIndex]];
        [self.lightBulbTimer invalidate];
        self.currentLightBulb = nil;
    }
}

- (NSInteger)getPrevLightBulbIndex {
    int currentIndex = self.currentLightBulb.intValue;
    return (currentIndex - 1) > 0 ? (currentIndex - 1) : ((currentIndex + 16 - 1) % 16);
}

- (void)playLightBulb {
    
    [self setLightBulbToGreyAt:[self getPrevLightBulbIndex]];
    [self setLightBulbToGreenAt:self.currentLightBulb.intValue];
    
    self.currentLightBulb = [NSNumber numberWithInt:((self.currentLightBulb.intValue + 1) % 16)];
}

- (BOOL)addNextRowToView:(BeatBoxSoundRow *)soundObject {
    // TODO: Return NO if there is not enough space for this row.
    // Create a new soundRow
    SoundRowView *row = [[SoundRowView alloc] initWithFrame:CGRectMake(nextRowXPos, nextRowYPos, ROW_LENGTH, ROW_HEIGHT)
                                              andController:self];
    // Update the nextRowYPos
    nextRowYPos += ROW_HEIGHT + SPACE;
    // Link the created row with the passed in soundObject.
    [self linkSound:soundObject withView:row];
    [self.soundRowViews addObject:row];
    // Add the created row to the subview.
    [self.view addSubview:row];
    // Add the created row to the array of soundObjects in the view.
    [self.soundObjectsInView addObject:soundObject];
    // Return that the row was successfully created and added.
    return YES;
}

/*
 * Sets the label which holds the BPM value.
 */
- (void)setBpmNumberLabelText:(NSInteger)tempo {
    self.bpmNumberLabel.text = [NSString stringWithFormat:@"%d", tempo];
}


/*
 * Performs updates based on the slider's value.
 */
- (IBAction)bpmSliderValueChanged:(UISlider *)sender {
    NSInteger value = sender.value;
    self.tempo = value;
    [self setBpmNumberLabelText:value];
}
   
/*
 * ****** MODEL ******
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
 */
- (void) viewDidUnload {
    [super viewDidUnload];
    // Stop recording if we are
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    self.audioRecorder = nil;
}

/**
 * awakeFromNib:
 */
- (void)awakeFromNib {
}


/*** CODE FOR THE FILE PICKER ***/

// Puts the subview IN view.
- (IBAction)soundNameButtonPushed:(UIButton *)sender {
    // Display sound file
//    picker.self.soundFilePicker.dataSource = self;
    self.soundFilePicker.delegate = self;
//    self.soundFilePicker.showsSelectionIndicator = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [self.pickerView setFrame:CGRectMake(0.0f, 0.0f, 280.0f, 300.0f)];
    [UIView commitAnimations];
    
    // Get the superview, and set it as the current sound row
    [self.currentSoundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    self.currentSoundView = (SoundRowView*)[sender superview];
    [self.currentSoundView setBackgroundColor:[UIColor redColor]];
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
    if ([pickerView isEqual:self.soundFilePicker]) {
        // Fill the rows
//        NSLog(@">>> Filling on row: %d", row);
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
    [self hidePickerView];
    int index = [self.soundFilePicker selectedRowInComponent:0];
    // On sound selection
    if (index == 0) {
        // record new sound file.
        [self addNewSound];
        // TODO clean up this logic flow. So many methods are called...
    
    } else {
        // update current view's soundButton to selected sound's name
        NSString* selectedSoundName = [self.alphabetizedFiles objectAtIndex:(index-1)];
        [self linkSound:[self.soundNameToRowDic objectForKey:selectedSoundName] withView:self.currentSoundView];
    }
    // Set the currentSoundView back to nil.
    [self.currentSoundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    self.currentSoundView = nil;
    
}

- (IBAction)pickerDeleteButtonPushed:(UIButton *)sender {
    [self hidePickerView];
    int index = [self.soundFilePicker selectedRowInComponent:0];
    if (index == 0) {
        // Do nothing...but that's not good UX.
    } else {
        // Get the selected sound name
        NSString* selectedSoundName = [self.alphabetizedFiles objectAtIndex:(index-1)];
        NSLog(@">>> Deleting sound file %@.", selectedSoundName);
        
        // Delete the sound file.
        BeatBoxSoundRow *soundObj = [self.soundNameToRowDic objectForKey:selectedSoundName];
        [self deleteFileWithPath:[self getFullPathForSoundRow:soundObj]];
        
        // Delete the sound name k,v pair from the dictionary.
        [self.soundNameToRowDic removeObjectForKey:selectedSoundName];
        
        // Delete any soundRow associated with this name.
        if (self.soundRowViews.count == 0) {
            NSLog(@"Empty soundRowViews!! :(");
        }
        for (SoundRowView *row in self.soundRowViews) {
            NSLog(@"Checking sound row '%@'...", row.soundButton.titleLabel.text);
            if ([row.soundButton.titleLabel.text isEqualToString:selectedSoundName]) {
                NSLog(@">>> >>> Removing a soundRowView.");
                [row removeFromSuperview];
                [self.soundRowViews removeObject:row];
            }
        }
    }
    // Set the currentSoundView back to nil.
    [self.currentSoundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    self.currentSoundView = nil;
}

- (void)hidePickerView {
    [UIView beginAnimations:nil context:NULL];
    [self.pickerView setFrame:CGRectMake(-280.0f, 0.0f, 280.0f, 300.0f)];
    [UIView commitAnimations];
}


- (void)deleteFileWithPath:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    NSLog(@"Path to file: %@", path);
    NSLog(@"File exists: %d", fileExists);
    NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:path]);
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        else {
            fileExists = [fileManager fileExistsAtPath:path];
            if (fileExists) NSLog(@"File not deleted :(");
            else NSLog(@"Success!!");
        }
    }
}


- (void) linkSound:(BeatBoxSoundRow *) sound withView:(SoundRowView *) soundView {

    NSLog(@"Linking sound: %@ with row: %@", sound.soundName, soundView.description);
    
    // Set the label of the button in the soundView to be the name of the sound.
    [soundView.soundButton setTitle:sound.soundName forState:UIControlStateNormal];
    
    // Set the 16th note array in the sound to match the soundView's array
    NSLog(@"notes per measure: %d", sound.notesPerMeasure);
    
    for (int i=0; i < sound.notesPerMeasure; i++) {
        BOOL isOn = [[soundView.noteButtonArray objectAtIndex:i] isSelected];
        [sound.sixteenthNoteArray setObject:[NSNumber numberWithBool:isOn] atIndexedSubscript:i];
    }
    NSLog(@"Sound array: %@", sound.sixteenthNoteArray);
    // TODO: Set sound.isSelected to match soundView.isSelected (isActivated)
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
//        [self.playButton.titleLabel setText:@"STOP"];
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self play];
        [self startPlayingLightBulbsAtIndex:0];
    } else {
        self.isPlaying = NO;
        [self stopPlayingLightBulbs];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
}

/*
    START THE PLAYBACK LOOP.
    Set counter to 0 and start timer.
 */
- (void)play {
    NSLog(@">> Beginning play loop!");
    self.globalCount = 0;
    [self performSelector:@selector(timerFireMethod:) withObject:nil afterDelay:[self bpmToSixteenth]];
    NSLog(@">> Loop should be playing.");
}

 /*
    Typically called every 16th note.
 */
- (void)timerFireMethod:(NSTimer *) timer {
    // Get the global count. (0-15)
    int noteNum = 0;
    // For now...
    noteNum = self.globalCount % 16;
//    NSLog(@">>> TimerFireMethod called on count: %d for beat: %d", self.globalCount, noteNum);
//    AVAudioPlayer *player;
    // For current sounds...
    for (BeatBoxSoundRow *sound in self.soundObjectsInView) {
        // ...if the sound is selected...
        if (sound.isSelected) {
//            noteNum = self.globalCount % sound.notesPerMeasure;
            // ...if the note is on for this count...
            if ([[sound.sixteenthNoteArray objectAtIndex:noteNum] boolValue] == YES) {
                // ...play the sound!
//                NSLog(@"Playing sound: %@.", sound.soundName);
                self.player = [self createAudioPlayerWithSound:sound];
                [self playPlaybackForPlayer:self.player];
            }
        }
    }
    self.globalCount++;
    if (self.isPlaying) {
        [self performSelector:@selector(timerFireMethod:) withObject:nil afterDelay:[self bpmToSixteenth]];
    }
}


// INIT THE AUDIOPLAYER WITH THE FILEPATH FOR THE SPECIFIED SOUND
- (AVAudioPlayer*)createAudioPlayerWithSound:(BeatBoxSoundRow*) sound {
    if (sound == nil) {
        NSLog(@"!!! Nil sound received for player! :(");
    }
    NSData *fileData = [NSData dataWithContentsOfFile:[self getFullPathForSoundRow:sound]
                                              options:NSDataReadingMapped
                                                error:nil];
//    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    self.player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    
    return self.player;
}

/*
    START PLAYBACK FOR THE SPECIFIED AUDIOPLAYER
 */
- (void)playPlaybackForPlayer:(AVAudioPlayer*)player {
    if (player != nil){
        player.delegate = self;
//        NSLog(@">>> About to play player: %@", player);
        if ([player prepareToPlay] && [player play]){
//            NSLog(@"Started playing the recorded audio.");
            
        } else {
            NSLog(@"Could not play the audio :(");
        }
    } else {
        NSLog(@"nil AVAudioPlayer received :(");
    }
}

/*
 * Calc 16th milliseconds from what bpm points to.
 * Equation: 60000/bpm/4 = 16th ms
 */
- (float)bpmToSixteenth {
    return ((60.0 / self.tempo) / 4.0);
}



/***************************************************************************
 ***** METHODS FOR RECORDING SOUNDS
 ***************************************************************************/
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


/*
    This gets called when a button on UIAlert view is clicked by user
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"OK"]) {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        if (![text isEqualToString:@""]) {
            NSLog(@"User pressed the OK button, start recording the sound...");
            [self startRecordCountdown:[[alertView textFieldAtIndex:0] text]];
        } else {
            NSLog(@"User entered empty string.");
        }
    } else if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"User pressed the Cancel button.");
    }
}


/*
    Start the timer to count down.
 */
- (void)startRecordCountdown:(NSString*)soundName {
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
    NSString *pathAsString = [self.soundDirectoryPath stringByAppendingString:[name stringByAppendingString:M4AEXTENSION]];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    // Initialize the recorder.
    self.audioRecorder = [self.audioRecorder initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]){
            NSLog(@"Successfully started to record in %@", audioRecordingURL);
            
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
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityMedium]
                forKey:AVEncoderAudioQualityKey];
    result = [NSDictionary dictionaryWithDictionary:settings];
    return result;
}


- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder {
    
    [paramRecorder stop];
    self.recordProgressLabel.text = @"Add a new sound";
    
    NSLog(@"url: %@",paramRecorder.url.lastPathComponent);
    
    
    //TODO FileManager???
    //TODO FileManager???
    //TODO FileManager???
    //TODO FileManager???
    //TODO FileManager???
    
    // TODO: save the recorded file
    BeatBoxSoundRow *recordedSound = [[BeatBoxSoundRow alloc] initWithPath:paramRecorder.url.lastPathComponent];
    
    NSLog(@"sound file stored: %@ \n\tin %@", recordedSound.soundName, recordedSound.soundFilePath);
    
    [self.soundNameToRowDic setObject:recordedSound forKey:recordedSound.soundName];
    if (self.currentSoundView == nil) {
        [self addNextRowToView:recordedSound];
    } else {
        [self linkSound:recordedSound withView:self.currentSoundView];
    }
    
    for (NSString* key in [self.soundNameToRowDic allKeys])
        NSLog(@"key: %@\tvalue: %@", key, [self.soundNameToRowDic objectForKey:key]);
    
    // resetting Record button title
//    [self.recButton setTitle:@"REC" forState:UIControlStateNormal];
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

- (NSMutableArray*)soundObjectsInView {
    if (!_soundObjectsInView)
        _soundObjectsInView = [[NSMutableArray alloc] init];
    return _soundObjectsInView;
}

- (NSMutableArray*)soundRowViews {
    if (!_soundRowViews)
        _soundRowViews = [[NSMutableArray alloc] init];
    return _soundRowViews;
}

/*
 * This method is invoked when a note on the view is 
 * toggled by the user
 * Calls toggleNoteArray to update the notes value
 */
- (IBAction)noteButtonPushed:(UIButton *)sender {

    NSLog(@"note button is pushed");
    sender.selected = !sender.selected;

    // NSLog(@"selected: %s", sender.selected ? "true" : "false");
    
    // Get the sound associated with the button.
    SoundRowView *row = (SoundRowView*)[sender superview];

    NSString *soundName = row.soundButton.titleLabel.text;
    
    NSLog(@"sound: %@", soundName);

    // update the sound object's note array
    BeatBoxSoundRow* soundObject = [self.soundNameToRowDic valueForKey:soundName];
    NSLog(@"OLD sound array: %@", soundObject.sixteenthNoteArray);
    [BeatBoxViewController toggleNoteArray:soundObject.sixteenthNoteArray
                                   atIndex:[sender.titleLabel.text intValue]];
    NSLog(@"NEW sound array: %@", soundObject.sixteenthNoteArray);
}

/*
 * Toggles the note at the given index
 */
+ (void)toggleNoteArray:(NSMutableArray*)noteArray atIndex:(NSUInteger)index {
    
    bool updatedNoteValue = YES;
    if ([[noteArray objectAtIndex:index] boolValue] == YES)
        updatedNoteValue = NO;
    
    [noteArray setObject:[NSNumber numberWithBool:updatedNoteValue] atIndexedSubscript:index];
}

/*
 * Returns the full path of the given sound object
 */
- (NSString*)getFullPathForSoundRow:(BeatBoxSoundRow *)soundRow {
    return [self.soundDirectoryPath stringByAppendingString:soundRow.soundFilePath];
}

/*
 * Creates a folder for the recorded sounds on the device
 * Returns the path of the newly created folder
 */
+ (NSString*)createSoundFolder {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"sounds"];
    
    // TODO FileManager?
    // http://stackoverflow.com/questions/3404689/iphone-objective-c-cant-delete-a-file
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];

    return [dataPath stringByAppendingString:@"/"];
}



@end

