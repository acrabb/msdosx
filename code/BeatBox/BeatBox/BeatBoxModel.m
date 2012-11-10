//
//  BeatBoxModel.m
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxModel.h"
#import "BeatBoxSoundRow.h"
#import <AVFoundation/AVFoundation.h>

@implementation BeatBoxModel

@synthesize players     = _players;
@synthesize timers      = _timers;


/*
 Mutable array of BeatBoxSoundRow objects to play.
 Object API:
 [- getName]
 - getFilePath
 - isSelected
 - getNoteArray
 - getTempo
 - isPlaying
 */
/*
- (void)play:(NSMutableArray *)sounds : (int *)bpm {
    NSLog(@">> Beginning play loop!");
    
    // Create and initialize the timer.
    NSTimer* timer = [[NSTimer alloc] init];
    
    // set playing to YES
    self.isPlaying = YES;
    
    // Call the timer fire method for the firt time.
    [timer performSelector:@selector(timerFireMethod:) withObject:timer afterDelay:0];
    
    // Create n AVAudioPlayers to play.
    self.players = [[NSMutableArray alloc] initWithCapacity:sounds.count];
    
    // Create n NSTimers to fire the players.
    self.timers = [[NSMutableArray alloc] initWithCapacity:sounds.count];
    
    // For every sound in sounds
    for (BeatBoxSoundRow* sound in sounds) {
        // Create an NSTimer
        NSTimer* timer =
            [NSTimer alloc] init
            [NSTimer scheduledTimerWithTimeInterval:[self bpmToSixteenth:bpm]
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:sound
                                            repeats:YES];
        // ...and add it to self.timers.
        [self.timers addObject:timer];
        [timer set]
        
        // Create an AVAudioPlayer
        AVAudioPlayer* player = [self createAudioPlayerWithSound:sound];
        
        // ...and add it to self.players.
        [self.players addObject:player];
    }
    
}
*/

/*
- (void)stop {
    // Set self.isPlaying to NO
    self.isPlaying = NO;
    
    // Invalidate the timer
    [self.timer invalidate];
    
    // Reset count to 0;
    self.globalCount = 0;
}
 */

/*
 Gets called every time the timer is fired.
 Typically called every 16th note.
 */
/*
- (void)timerFireMethod:(NSTimer *)timer {
    // Get the global count. (0-15)
    int count = self.globalCount % self.NOTES_PER_MEASURE;
    
    // If we are playing
    if (self.isPlaying) {
        // ...for each sound
        for (BeatBoxSoundRow* sound in self.sounds) {
            // ...if the bit is on.
            // [NOTE: can multiply by a multiplier if playing 8th or quarter notes instead]
            if ([sound.sixteenthNoteArray objectAtIndex:count] != 0) {
                // ...play the sound
                
                // Create an AVAudioPlayer with that sound
                AVAudioPlayer* player = [self createAudioPlayerWithSound:sound];
                
                // Prepare to play and play the sound
                [self playPlaybackForPlayer:player];
            }
        }
        
        // Then do it again!!
        self.globalCount++;
        [timer performSelector:@selector(timerFireMethod:)
                    withObject:timer
                    afterDelay:[self bpmToSixteenth:bpm]]
    }
}
*/

/*
 START PLAYBACK FOR THE SPECIFIED AUDIOPLAYER
 */
/*
- (void)playPlaybackForPlayer:(AVAudioPlayer*) player {
    if (player != nil){
        player.delegate = self;
 
        // Prepare to play and start playing
        if ([player prepareToPlay] && [player play]){
            NSLog(@"Started playing the recorded audio.");
        } else {
            NSLog(@"Could not play the audio.");
        }
    } else {
        NSLog(@"nil AVAudioPlayer received.");
    }
}
*/

/*
- (int)bpmToSixteenth:(int *) bpm {
    // Calc 16th milliseconds from what bpm points to.
    return ((60000 / *bpm) / 16);
}
*/


/*
    INIT AN AUDIOPLAYER WITH THE FILEPATH FOR THE SPECIFIED SOUND
 */
/*
- (AVAudioPlayer*)createAudioPlayerWithSound:(BeatBoxSoundRow*) sound {
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:sound.soundFilePath
                                              options:NSDataReadingMapped
                                                error:nil];
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData
                                                          error:nil];
    return player;
}
*/


@end
