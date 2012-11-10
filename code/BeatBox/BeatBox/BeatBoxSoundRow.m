//
//  BeatBoxSoundRow.m
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxSoundRow.h"

@implementation BeatBoxSoundRow

@synthesize soundFilePath   = _soundFilePath;
@synthesize soundName       = _soundName;
@synthesize sixteenthNoteArray  = _sixteenthNoteArray;
@synthesize volume          = _volume;


- (void)testingThings {
    NSString* tester = [[NSString alloc] init];
}


- (id) init {
    // SET THE DEFAULT NAME
    self.soundName = @"defaultName";
    
    // SET THE DEFAULT ARRAY TO QUARTER NOTES.
    self.sixteenthNoteArray = [[NSMutableArray alloc] initWithObjects:
                               0,0,0,0,
                               0,0,0,0,
                               0,0,0,0,
                               0,0,0,0,nil]; //[BeatBoxSoundRow defaultArray];
    
    // SET THE DEFAULT VOLUME
    self.volume = 1.0;
    
    return self;
}

- (id) initWithName:(NSString*)         name
              array:(NSMutableArray*)   array
             volume:(float)             volume
           filePath:(NSString*)         filePath {
    
    self.soundName = name;
    self.sixteenthNoteArray = array;
    self.volume = volume;
    self.soundFilePath = filePath;
    
    return self;
}

+ (NSMutableArray*) defaultArray {
    NSMutableArray* temp = [[NSMutableArray alloc] initWithObjects:
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            nil];
//    [temp setObject:[NSNumber numberWithInt:1] atIndexedSubscript:0];
//    [temp setObject:[NSNumber numberWithInt:1] atIndexedSubscript:4];
//    [temp setObject:[NSNumber numberWithInt:1] atIndexedSubscript:8];
//    [temp setObject:[NSNumber numberWithInt:1] atIndexedSubscript:12];
    
    return temp;
}


@end
