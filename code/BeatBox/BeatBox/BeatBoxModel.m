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

//- (void)playSoundArray:(NSMutableArray *)bitArray {
//    while (shouldPlay) {
//        <#statements#>
//    }
//}


@end
