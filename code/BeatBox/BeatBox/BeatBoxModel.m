//
//  BeatBoxModel.m
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxModel.h"

@implementation BeatBoxModel

@synthesize testArray = _testArray;


- (void)initSoundArray:(NSMutableArray*)bitArray {
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:16];
    array[0] = [NSNumber numberWithInt:1];
    array[4] = [NSNumber numberWithInt:1];
    array[8] = [NSNumber numberWithInt:1];
    array[12] = [NSNumber numberWithInt:1];
}


// Mutable array of BeatBoxSoundRow objects to play.
/*
 Object API:
 [- getName]
 - getFilePath
 - isSelected
 - getNoteArray
 - getTempo
 */
- (void)play:(NSMutableArray *)sounds {
    NSLog(@">> Beginning playing measure for sound %@", sound.soundName);
    
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


//- (void)playSoundArray:(NSMutableArray *)bitArray {
//    while (shouldPlay) {
//        <#statements#>
//    }
//}


@end
