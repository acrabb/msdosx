//
//  BeatBoxModel.h
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BeatBoxSoundRow.h"

@interface BeatBoxModel : NSObject

@property NSMutableArray* players;
@property NSMutableArray* timers;


// Mutable array of SoundRowView objects to play.
/*
    Object API:
        [- getName]
        - getFilePath
        - isSelected
        - getNoteArray
    - getTempo
 */
- (void)    play:(NSMutableArray*) sounds;
- (int)     bpmToSixteenth:(int *) bpm;
- (void)    timerFireMethod:(NSTimer *) timer;
- (AVAudioPlayer*) createAudioPlayerWithSound:(BeatBoxSoundRow*) sound;
- (void)    playPlaybackForPlayer:(AVAudioPlayer*) player;


@end
