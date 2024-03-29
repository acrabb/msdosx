//
//  BeatBoxViewController.m
//  BeatBox
//
//  Created by André Crabb on 11/5/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxModel.h"
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
@property (strong, nonatomic) IBOutlet UIPickerView *soundFilePicker;

@property (strong, nonatomic) SoundRowView          *currentSoundView;
@property (strong, nonatomic) IBOutlet UILabel *countDownViewLabel;
@property (strong, nonatomic) NSMutableArray        *soundObjectsInView;
@property (strong, nonatomic) NSMutableArray        *soundRowViews;
@property (strong, nonatomic) NSMutableArray        *activatedSounds;

@property (strong, nonatomic) BeatBoxLightBulbView  *lightBulbView;

// NON-VIEW OBJECTS
@property (strong, nonatomic) AVAudioRecorder       *audioRecorder;
@property (strong, nonatomic) NSTimer               *playTimer;
@property (strong, nonatomic) NSMutableDictionary   *soundNameToRowDic; // TODO
@property (strong, nonatomic) NSMutableArray        *alphabetizedFiles;
@property (strong)            NSMutableDictionary   *audioPlayers;

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
@property (strong, nonatomic) BeatBoxModel*         ourModel;

@property (strong, nonatomic) NSMutableDictionary   *audioSources;
@property (strong, nonatomic) NSMutableDictionary   *audioBuffers;
@property (strong, nonatomic) IBOutlet UIView       *recordingActionView;
@property (strong, nonatomic) NSString*             recordedFilePath;

@end



/***************************************************************************
 ***** BEGIN IMPLEMENATION
 ***************************************************************************/
@implementation BeatBoxViewController

// UI OBJECTS
@synthesize playButton          = _playButton;
@synthesize soundFilePicker     = _soundFilePicker;
@synthesize pickerView          = _pickerView;
@synthesize soundRowViews       = _soundRowViews;
@synthesize activatedSounds     = _activatedSounds;
@synthesize soundObjectsInView  = _soundObjectsInView;
@synthesize bpmNumberLabel      = _bpmNumberLabel;
@synthesize lightBulbView       = _lightBulbView;
@synthesize countDownView       = _countDownView;
@synthesize recordingActionView = _recordingActionView;

// NON-UI OBJECTS
@synthesize audioRecorder       = _audioRecorder;
@synthesize soundNameToRowDic   = _soundNameToRowDic;
@synthesize alphabetizedFiles   = _alphabetizedFiles;
@synthesize audioPlayers        = _audioPlayers;

// OTHER VARS
@synthesize isRecording         = _isRecording;
@synthesize isPlaying           = _isPlaying;
@synthesize counterSecond       = _counterSecond;
@synthesize recordedFileName    = _recordedFileName;
@synthesize globalCount         = _globalCount;
@synthesize lightBulbTimer      = _lightBulbTimer;
@synthesize currentLightBulb    = _currentLightBulb;

@synthesize audioSources        = _audioSources;
@synthesize audioBuffers        = _audioBuffers;

NSString*   M4AEXTENSION        = @".m4a";

int MAX_SOUND_ROWS = 6;
int SOUND_ROW_CONTAINER_HEIGHT = 36;
int ROW_HEIGHT  = 34;
int ROW_LENGTH  = 480;
int SPACE       = 2;

ALCdevice   *openALDevice;
ALCcontext  *openALContext;
ALuint      outputSources;
ALuint      outputBuffers;

int counter = 0;

/***************************************************************************
 ***** METHODS FOR THE VIEW
 ***************************************************************************/

/**
 * viewDidLoad:
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createOpenALDevice];
    [self createOpenALContext];
//    [self createOutputBuffers:MAX_SOUND_ROWS];
//    [self createOutputSources:MAX_SOUND_ROWS];
    
    self.countDownView.hidden = YES;
    self.recordingActionView.hidden = YES;
    self.countDownViewLabel.text = @"";
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background_04.png"]];
    
    // Allocate space for the recorder and player.
    self.audioRecorder  = [AVAudioRecorder alloc];
    
 
    // TODO: Set the tempo and tempo setter
    self.tempo = 100;
    [self setBpmNumberLabelText:self.tempo];
    self.audioPlayers = [[NSMutableDictionary alloc] initWithCapacity:MAX_SOUND_ROWS];
    // OpenAL
    self.audioBuffers = [[NSMutableDictionary alloc] initWithCapacity:MAX_SOUND_ROWS];
    self.audioSources = [[NSMutableDictionary alloc] initWithCapacity:MAX_SOUND_ROWS];
    
    /*** Fill dictionary with sounds from folder ***/
    [self fillDictionaryWithSounds];
    
    // Set the label to a default value.
    
    // add light bulb view
    BeatBoxLightBulbView *lightBulbView = [[BeatBoxLightBulbView alloc] initWithFrame:CGRectMake(0, 0, ROW_LENGTH, ROW_HEIGHT) andController:self];
    [self.view addSubview:lightBulbView];
    self.lightBulbView = lightBulbView;
    
    /*
     * Initialize the rows with as many sounds as we can fit in
     * some of the sounds we
     */
    NSArray *bBSoundRows = [self.soundNameToRowDic allValues];
    for (BeatBoxSoundRow* bBSoundRow in bBSoundRows) {
        [self addNextRowToView:bBSoundRow];
    }

    [self putCountDownViewOnTop];
    
    NSLog(@"soundObjectsInView size: %d", self.soundObjectsInView.count);
    
    
    
    /////////////////////////////////////////////
    // OpenAL testing
    //////////////////
    
    //    self.ourModel = [[BeatBoxModel alloc] init];
    
    /*/
    
    ALuint outputBuffer = [self createOutputBuffer];
    ALuint outputSource = [self createOutputSource];
    
    NSString *filePath = [self getFullPathForSoundRow:[self.soundObjectsInView objectAtIndex:0]];
    AudioFileID afid = [self getAFIDForFilePath:filePath];
    UInt32 bytesRead = [self getBytesReadForAFID:afid];
    void* audioData = [self allocMemoryForBytes:bytesRead forAFID:afid];
    [self copyAudioData:audioData forLength:bytesRead toBuffer:outputBuffer];
    
    [self attachBuffer:outputBuffer toSource:outputSource];
    [self playAudioForSource:outputSource];
    
    [NSThread sleepForTimeInterval:1];
     /**/
    // More cleaning.
    //    NSLog(@"Cleaning.");
    //    alDeleteSources(1, &outputSource);
    //    alDeleteBuffers(1, &outputBuffer);
    //    alcDestroyContext(openALContext);
    //    alcCloseDevice(openALDevice);
    //    NSLog(@"Done cleaning.");
    
    /////////////////////////////////////////////
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
    
    NSLog(@"Cleaning.");
    ALuint outputSource;
    for (NSNumber *src in self.audioSources.allValues) {
        outputSource = [src unsignedIntValue];
        alDeleteSources(1, &outputSource);
    }
    
    ALuint outputBuffer;
    for (NSNumber *buf in self.audioBuffers.allValues) {
        outputBuffer = [buf unsignedIntValue];
        alDeleteBuffers(1, &outputBuffer);
    }
    
    alcDestroyContext(openALContext);
    alcCloseDevice(openALDevice);
}

/**
 * awakeFromNib:
 */
- (void)awakeFromNib {
}



- (void) createOpenALDevice {
    NSLog(@"Creating a device.");
    openALDevice = alcOpenDevice(NULL);
    // Check errors.
    ALenum error = alGetError();
    if (AL_NO_ERROR != error) {
        NSLog(@"Error %d when attemping to open device", error);
    }
}
    
- (void) createOpenALContext {
    NSLog(@"Creating a context.");
    openALContext = alcCreateContext(openALDevice, NULL);
    alcMakeContextCurrent(openALContext);
}

- (ALuint) createOutputSources:(int)num {
    ALuint outputSource;
    alGenSources(num, &outputSource);
    NSLog(@"Creating a source: %i", outputSource);
    // You can set various source parameters using alSourcef. For example, you can set the pitch and gain:
    alSourcef(&outputSource, AL_PITCH, 1.0f);
    alSourcef(outputSource, AL_GAIN, 1.0f);
    return (ALuint)outputSource;
}

- (ALuint) createOutputBuffers:(int)num {
    // Create a BUFFER
    ALuint outputBuffer;
    alGenBuffers(num, &outputBuffer);
    NSLog(@"Creating a buffer %i:", outputBuffer);
    return outputBuffer;
}

- (AudioFileID) getAFIDForFilePath:(NSString *)filePath {
    // Get reference to file.
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    // Open file and get AudioFileID
    AudioFileID afid;
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &afid);
    if (0 != openResult) {
        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
        return 0;
    }
    return afid;
}

- (UInt32) getBytesReadForAFID:(AudioFileID)afid {
    // Get file size.
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    if (0 != getSizeResult) {
        NSLog(@"An error occurred when attempting to determine the size of afid %@: %ld", afid, getSizeResult);
    }
    UInt32 bytesRead = (UInt32)fileSizeInBytes;
    return bytesRead;
}

- (void*) allocMemoryForBytes:(UInt32)bytesRead
                     forAFID:(AudioFileID)afid {
    // Set memory for audio data.
    void* audioData = malloc(bytesRead);
    // Fill the buffer with file data.
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    if (0 != readBytesResult) {
        NSLog(@"An error occurred when attempting to read data from bytesRead %lu: %ld", bytesRead, readBytesResult);
    }
    // Close file
    AudioFileClose(afid);
    return audioData;
}

- (void) copyAudioData:(void*)audioData
             forLength:(UInt32)bytesRead
              toBuffer:(ALuint)outputBuffer {
    // Copy data to al buffer
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
    // clean...
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
}

- (void) attachBuffer:(ALuint)outputBuffer
             toSource:(ALuint)outputSource {
    alSourcei(outputSource, AL_BUFFER, outputBuffer);
}

- (void) playAudioForSource:(ALuint)outputSource {
    // Play!!
    NSLog(@"Playing.");
    alSourcePlay(outputSource);
    NSLog(@"Done playing.");
}


- (void) newSoundSetUp:(BeatBoxSoundRow*)sound {
    
	ALuint outputBuffer = [self createOutputBuffers:1];
    ALuint outputSource = [self createOutputSources:1];
//	ALuint outputBuffer = outputBuffers + counter;
//    ALuint outputSource = outputSources + counter;
    
    NSLog(@">>> Buffer %i; source %i", outputBuffer, outputSource);
    
    NSLog(@">>> Adding buffer and source to dicts");
    [self.audioBuffers setObject:[NSNumber numberWithUnsignedInt:outputBuffer] forKey:sound.soundName];
    [self.audioSources setObject:[NSNumber numberWithUnsignedInt:outputSource] forKey:sound.soundName];
    
	NSString *filePath = [self getFullPathForSoundRow:[self.soundObjectsInView objectAtIndex:0]];
    NSLog(@">>> Adding sound for path %@", filePath);
    AudioFileID afid = [self getAFIDForFilePath:filePath];
    UInt32 bytesRead = [self getBytesReadForAFID:afid];
    void* audioData = [self allocMemoryForBytes:bytesRead forAFID:afid];
    [self copyAudioData:audioData forLength:bytesRead toBuffer:outputBuffer];
    
    
    NSLog(@">>> Attaching buffer %i to source %i", outputBuffer, outputSource);
    [self attachBuffer:outputBuffer toSource:outputSource];
    
//    NSLog(@"Playing audio for source: %i", outputSource);
//    [self playAudioForSource:outputSource];
    counter++;
}


- (IBAction)cancelRecording:(UIButton *)sender {
    [self deleteFileWithPath:self.recordedFilePath];
    self.recordingActionView.hidden = YES;
    self.countDownView.hidden = YES;
}

- (IBAction)RetryRecording:(UIButton *)sender {
    [self deleteFileWithPath:self.recordedFilePath];
    self.recordingActionView.hidden = YES;
    [self startRecordCountdown:self.recordedFileName];
}

- (IBAction)saveRecording:(UIButton *)sender {
    
    BeatBoxSoundRow *recordedSound = [[BeatBoxSoundRow alloc] initWithPath:self.recordedFilePath];
    
    NSLog(@"sound file stored: %@ \n\tin %@", recordedSound.soundName, recordedSound.soundFilePath);
    
    [self.soundNameToRowDic setObject:recordedSound forKey:recordedSound.soundName];
    if (self.currentSoundView == nil) {
        [self addNextRowToView:recordedSound];
    } else {
        [self linkSound:recordedSound withView:self.currentSoundView];
    }
    
    for (NSString* key in [self.soundNameToRowDic allKeys])
        NSLog(@"key: %@\tvalue: %@", key, [self.soundNameToRowDic objectForKey:key]);

    self.recordingActionView.hidden = YES;
    self.countDownView.hidden = YES;
}

- (void)hideRecordingActionView {
    self.recordingActionView.hidden = YES;
}

- (void)showRecordingActionView {
    self.recordingActionView.hidden = NO;
}

- (void)putCountDownViewOnTop {
    [self.countDownView removeFromSuperview];
    [self.view addSubview:self.countDownView];
}

- (CGRect)getCGRectForNextSoundRowView {
    return CGRectMake(0, (self.soundRowViews.count + 1) * SOUND_ROW_CONTAINER_HEIGHT, ROW_LENGTH, ROW_HEIGHT);
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
    UIImageView *lightBulb = (UIImageView*)[self.lightBulbView viewWithTag:lightBulbIndex + 1];
//    NSLog(@"current image: %@",lightBulb.image.description);
    [lightBulb setImage:[UIImage imageNamed:@"led-circle-grey-md.png"]];
}

- (void)setLightsOff {
    for (id lightBulb in [self.lightBulbView subviews]) {
        if ([lightBulb isKindOfClass:[UIImageView class]]) {
            UIImageView *lightBulbImageView = (UIImageView*)lightBulb;
//            NSLog(@"current lightBulb to set off: %@", [lightBulbImageView description]);
            [lightBulbImageView setImage:[UIImage imageNamed:@"led-circle-grey-md.png"]];
        }
    }
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

- (void)playLightBulbAtIndex:(NSInteger)index {
    self.currentLightBulb = [NSNumber numberWithInt:index];
    
    [self setLightBulbToGreenAt:index];
    [self setLightBulbToGreyAt:[self getPrevLightBulbIndex]];
}

/*
- (void)replaceRowView:(SoundRowView *)oldSoundRowView with:(NSString*)soundName {

        // create the soundRowView for this sound
    
        SoundRowView *soundRowView = [[SoundRowView alloc] initWithFrame:[oldSoundRowView frame]
andController:self];
    
        [soundRowView.soundButton setTitle:soundName forState:UIControlStateNormal];
        soundRowView.noteButtonArray = oldSoundRowView.noteButtonArray.copy;
    
        [self.soundRowViews removeObject:oldSoundRowView];
        [oldSoundRowView removeFromSuperview];
    
        [self.soundRowViews addObject:soundRowView];
        [self.view addSubview:soundRowView];
        
        NSLog(@"soundRowView array updated, new size: %d", self.soundRowViews.count);
        // [self linkSound:soundObject withView:soundRowView];
        
        // Also create the AudioPlayer object for this sound.
//        SoundRowView *
    
    
    
        AVAudioPlayer *player = [self createAudioPlayerWithSound:soundObject];
        [self.audioPlayers setObject:player forKey:soundName];
        [player prepareToPlay];
        //        [self.audioPlayers addObject:player];
        
        [self.soundObjectsInView addObject:soundObject];
    }
    [self putCountDownViewOnTop];
    
}
 */
    
- (void)addNextRowToView:(BeatBoxSoundRow *)soundObject {

    // add a new row only if there's enough space
    if (self.soundRowViews.count < MAX_SOUND_ROWS) {
    
        // create the soundRowView for this sound
        SoundRowView *soundRowView = [[SoundRowView alloc] initWithFrame:[self getCGRectForNextSoundRowView]
                                                       andController:self];
        [self.soundRowViews addObject:soundRowView];
        
        [self.view addSubview:soundRowView];
        [self.soundObjectsInView addObject:soundObject];
        
        NSLog(@"soundRowView array updated, new size: %d", self.soundRowViews.count);

        [self linkSound:soundObject withView:soundRowView];
        
        // Also create the AudioPlayer object for this sound.
        AVAudioPlayer *player = [self createAudioPlayerWithSound:soundObject];
        [self.audioPlayers setObject:player forKey:soundObject.soundName];
        
        // TODO: move this to LinkSound fn
        // OpenAL
//        ALuint audioBuffer = [self createOutputBuffer];
//        ALuint audioSource = [self createOutputSource];
//        [self.audioBuffers setObject:[NSNumber numberWithUnsignedInt:audioBuffer] forKey:soundObject.soundName];
//        [self.audioSources setObject:[NSNumber numberWithUnsignedInt:audioBuffer] forKey:soundObject.soundName];
        
        
//        [player prepareToPlay];
        
    }
    [self putCountDownViewOnTop];
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




/*** CODE FOR THE FILE PICKER ***/

- (void)popPickerView:(SoundRowView*)soundRowView {

    if (self.isPlaying)
        [self stop];
    
    self.soundFilePicker.delegate = self;
    
    [self.view addSubview:self.pickerView];
    [UIView beginAnimations:nil context:NULL];
    
    [self.pickerView setFrame:CGRectMake(0.0f, 0.0f, 480.0f, 300.0f)];
    [UIView commitAnimations];
    
    // Get the superview, and set it as the current sound row
    self.currentSoundView = soundRowView;
}

// Puts the subview IN view.
- (IBAction)soundNameButtonPushed:(UIButton *)sender {
    [self popPickerView:(SoundRowView*)[sender superview]];
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
    [self putCountDownViewOnTop];
}

- (NSArray*)findNewSoundsFor:(NSMutableArray*)soundRowViews {
    
    // all sound names
    NSMutableArray *bBSoundObjNames = [[self.soundNameToRowDic allKeys] mutableCopy];
    
    for (id soundRowView in soundRowViews) {
        
        SoundRowView *rowView = (SoundRowView*)soundRowView;
        // sound name

        NSString *soundNameInView = rowView.soundButton.titleLabel.text;
        
        [bBSoundObjNames removeObject:soundNameInView];
    }
    return (NSArray*)bBSoundObjNames;
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
        [self.audioPlayers removeObjectForKey:selectedSoundName];
        //OpenAL
        [self.audioBuffers removeObjectForKey:selectedSoundName];
        [self.audioSources removeObjectForKey:selectedSoundName];
        
        if (self.soundRowViews.count == 0) {
            NSLog(@"Empty soundRowViews!! :(");
        }
        
        NSMutableArray *temp = [self.soundRowViews mutableCopy];
        
        BOOL rowDeleted = NO;
        BOOL middleRowDeleted = NO;
        
        // Delete any soundRow associated with this name
        for (SoundRowView *row in self.soundRowViews) {
            /* 
             * Previous row is a middle row
             * If prev is deleted, need to rearrange the sound views at the end
             */
            if (rowDeleted)
                middleRowDeleted = YES;
            
            NSLog(@"Checking sound row '%@'...", row.soundButton.titleLabel.text);
            
            if ([row.soundButton.titleLabel.text isEqualToString:selectedSoundName]) {
                NSLog(@">>> >>> Removing a soundRowView.");
                [row removeFromSuperview];
                [temp removeObject:row];
                rowDeleted = YES;
            }
        }

        /*
         * We have to cleanUp the sound views if a middle row has been deleted
         * No need to rearrange if only the last row has been deleted
         */
        if (middleRowDeleted)
            [self cleanUpSoundRowViewArr:temp];
        
        self.soundRowViews = temp;
        
        if (rowDeleted && self.soundNameToRowDic.count > temp.count) {
            NSArray* soundObjectNames = [self findNewSoundsFor:temp];
            for (NSString *soundName in soundObjectNames) {
                if (self.soundRowViews.count >= MAX_SOUND_ROWS)
                    break;
                else
                    [self addNextRowToView:[self.soundNameToRowDic objectForKey:soundName]];
            }
        }
    }
    // Set the currentSoundView back to nil.
    [self.currentSoundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    self.currentSoundView = nil;
}

- (IBAction)pickerCancelButtonPushed:(UIButton *)sender {
    [self hidePickerView];
}

/*
 * rearranges the sound rows to fill the gap created by the deleted rows
 */
- (void)cleanUpSoundRowViewArr:(NSMutableArray*)soundRowView {

    // accounting for lightBulbView
    int numRows = 1;
    
    for (SoundRowView *row in soundRowView) {
        if (row.frame.origin.y != numRows * SOUND_ROW_CONTAINER_HEIGHT)
            row.frame = CGRectMake(0, numRows * SOUND_ROW_CONTAINER_HEIGHT, ROW_LENGTH, ROW_HEIGHT);
        numRows++;
    }
}

- (void)hidePickerView {
    [UIView beginAnimations:nil context:NULL];
    [self.pickerView setFrame:CGRectMake(-480.0f, 0.0f, 480.0f, 300.0f)];
    [UIView commitAnimations];
    [self.pickerView removeFromSuperview];

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

    [self.soundRowViews removeObject:soundView];
    NSString *oldName = soundView.soundButton.titleLabel.text;

    BeatBoxSoundRow *oldSound = [self.soundNameToRowDic objectForKey:oldName];
    
    // Set the label of the button in the soundView to be the name of the sound.
    [soundView.soundButton setTitle:sound.soundName forState:UIControlStateNormal];
    
    // Set the 16th note array in the sound to match the soundView's array
    NSLog(@"notes per measure: %d", sound.notesPerMeasure);
    
    BOOL old = NO;
    for (BeatBoxSoundRow *oldSoundInView in self.soundObjectsInView) {
        NSLog(@"in:%@\told:%@", oldSoundInView.soundName, oldName);
        if ([oldSoundInView.soundName isEqualToString:oldName]) {
            int i = 0;
            for (NSNumber *note in oldSoundInView.sixteenthNoteArray) {
                if ([note boolValue] == YES) {
                    NSLog(@"%d is pushed", i);
                    [sound.sixteenthNoteArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:i];
                } else {
                    NSLog(@"%d is NOT pushed", i);
                    [sound.sixteenthNoteArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:i];
                }
                i++;
            }
            old = YES;
            break;
        }
    }
    
    if (!old) {
            NSLog(@"Not an old row");
        for (int i=0; i < sound.notesPerMeasure; i++)
            [sound.sixteenthNoteArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:i];
    }
    
    [self.soundRowViews addObject:soundView];
    [self.soundObjectsInView removeObject:oldSound];
    [self.soundObjectsInView addObject:sound];
    
    NSLog(@"sound: %@", sound);
    
    if (![self.audioPlayers objectForKey:sound.soundName]) {
        AVAudioPlayer *player = [self createAudioPlayerWithSound:sound];
        NSLog(@"setting object player: %@ for soundName: %@", player, sound.soundName);
        [self.audioPlayers setObject:player forKey:sound.soundName];
    }
//    NSLog(@"Sound array: %@", sound.sixteenthNoteArray);
    // TODO: Set sound.isSelected to match soundView.isSelected (isActivated)
    
    // OpenAL
    [self newSoundSetUp:sound];
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
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self play];
//        [self startPlayingLightBulbsAtIndex:0];
    } else {
        [self stop];
    }
}

- (void)stop {
    self.isPlaying = NO;
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

/*
    START THE PLAYBACK LOOP.
    Set counter to 0 and start timer.
    WE SHOULD BE USING OPENAL!!! AVAUDIOPLAYER IS TOO SLOW.
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
    [self playLightBulbAtIndex:noteNum];
    AVAudioPlayer *player;
    for (BeatBoxSoundRow *sound in self.soundObjectsInView) {
        player = [self.audioPlayers objectForKey:sound.soundName];
        [player stop];
//        if (sound.isSelected) {
//            noteNum = self.globalCount % sound.notesPerMeasure;
            if ([[sound.sixteenthNoteArray objectAtIndex:noteNum] boolValue] == YES) {
                NSLog(@"Playing sound: %@.", sound.soundName);
                // OpenAL
                ALuint outSource = [[self.audioSources objectForKey:sound.soundName] unsignedIntValue];
                NSLog(@">>> About to play for source %i", outSource);
//                alSourcePlay(outSource);
                // TODO FORNOW
                [self playPlaybackForPlayer:player]; //plays from 0.
            }
//        }
    }
    self.globalCount++;
    if (self.isPlaying) {
        [self performSelector:@selector(timerFireMethod:) withObject:nil afterDelay:[self bpmToSixteenth]];
    } else {
        [self setLightsOff];
    }
}


// INIT THE AUDIOPLAYER WITH THE FILEPATH FOR THE SPECIFIED SOUND
- (AVAudioPlayer*)createAudioPlayerWithSound:(BeatBoxSoundRow*) sound {
    if (sound == nil) {
        NSLog(@"!!! Nil sound received for player! :(");
    }
    NSLog(@"Creating player for path: %@", [self getFullPathForSoundRow:sound]);
    NSData *fileData = [NSData dataWithContentsOfFile:[self getFullPathForSoundRow:sound]
                                              options:NSDataReadingMapped
                                                error:nil];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    player.delegate = self;
    player.enableRate = YES;
    player.rate = 1;
    
    return player;
}

/*
    START PLAYBACK FOR THE SPECIFIED AUDIOPLAYER
 */
- (void)playPlaybackForPlayer:(AVAudioPlayer*)player {
    if (player != nil){
//        NSLog(@">>> About to play player: %@", player);
        player.currentTime = 0;
        [player play];
    } else {
        NSLog(@"nil AVAudioPlayer received :(");
    }
}

/*
 * Calc 16th milliseconds from what bpm points to.
 * Equation: 60000/bpm/4 = 16th in ms (* 1000 = 16th in seconds)
 */
- (float)bpmToSixteenth {
    return ((60.0 / self.tempo) / 4.0);
}



/***************************************************************************
 ***** METHODS FOR RECORDING SOUNDS
 ***************************************************************************/

- (IBAction)addNewSound {
    // TODO: Stop the audio.
    if (self.isPlaying) {
        [self stop];
    }
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
    // add a new row only if there's enough space
    if (self.soundRowViews.count < MAX_SOUND_ROWS) {
        
        // [self addNextRowToView: ]
        
        // create the soundRowView for this sound
        SoundRowView *soundRowView = [[SoundRowView alloc] initWithFrame:[self getCGRectForNextSoundRowView] andController:self];
    
        // pop up the view
        [self popPickerView:soundRowView];

        
        // add the soundRowView to the view
        [self.soundRowViews addObject:soundRowView];
        [self.view addSubview:soundRowView];
        
        [self linkSound:soundObject withView:soundRowView];
        
        // Also create the AudioPlayer object for this sound.
        AVAudioPlayer *player = [self createAudioPlayerWithSound:soundObject];
        [self.audioPlayers setObject:player forKey:soundObject.soundName];
        [player prepareToPlay];
        //        [self.audioPlayers addObject:player];
        
        [self.soundObjectsInView addObject:soundObject];
}
*/

/*
    This gets called when a button on UIAlert view is clicked by user
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"OK"]) {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        if (![text isEqualToString:@""]) {
            NSLog(@"User pressed the OK button, start recording the sound...");
            // TODO: Display a view saying prepare to record.
            // Display the countdown on this view.
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
    [self prepareToRecordForName:soundName];

    self.countDownViewLabel.text = @"";
    self.countDownView.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countLabel:) userInfo:nil repeats:YES];
}


- (void)countLabel2:(NSTimer*)timer {
    
}


/*
    Called by the timer to countdown to recording.
 */
-(void)countLabel:(NSTimer*)timer {
    
    if (self.counterSecond > 0) {
        self.countDownViewLabel.text = [NSString stringWithFormat:@"%d", self.counterSecond];
        self.counterSecond--;
    } else {
        [timer invalidate];
        [self record];
    }
}

-(void) prepareToRecordForName:(NSString*)name {
    // Recordig settings.
    NSError *error = nil;
    NSString *pathAsString = [self.soundDirectoryPath stringByAppendingString:[name stringByAppendingString:M4AEXTENSION]];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    
    // Initialize the recorder.
    self.audioRecorder = [self.audioRecorder initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    self.audioRecorder.delegate = self;
    [self.audioRecorder prepareToRecord];
}

- (void)record {
    if (self.audioRecorder != nil) {
        /* Prepare the recorder and then start the recording */
        if ([self.audioRecorder record]){
//            NSLog(@"Successfully started to record in %@", audioRecordingURL);
            self.countDownViewLabel.text = @"Go";
            
            /* After 1 second, let's stop the recording process */
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder afterDelay:0.5f];
            
        } else {
            NSLog(@"Failed to record.");
            self.audioRecorder = nil;
        }
    } else {
        NSLog(@"Failed to create an instance of the audio recorder.");
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
                       withObject:self.audioRecorder afterDelay:0.5f];
            
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
    [settings setValue:[NSNumber numberWithFloat:88200.0f]
//    [settings setValue:[NSNumber numberWithFloat:44100.0f]
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

    self.countDownViewLabel.text = @"Done";
    self.recordedFilePath = paramRecorder.url.lastPathComponent;
    self.recordingActionView.hidden = NO;
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
//    NSLog(@"OLD sound array: %@", soundObject.sixteenthNoteArray);
    [BeatBoxViewController toggleNoteArray:soundObject.sixteenthNoteArray
                                   atIndex:[sender.titleLabel.text intValue]];
//    NSLog(@"NEW sound array: %@", soundObject.sixteenthNoteArray);
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

