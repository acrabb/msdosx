//
//  BeatBoxModel.h
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeatBoxModel : NSObject

@property int bpm;
@property NSMutableArray* testArray;

- (void)playSoundArrays;
- (void)playSoundArray:(NSMutableArray*) bitArray;

// Mutable array of SoundRowView objects to play.
/*
    Object API:
        [- getName]
        - getFilePath
        - isSelected
        - getNoteArray
    - getTempo
 */
- (void)play:(NSMutableArray*) sounds;


@end
