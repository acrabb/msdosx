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
@synthesize notesPerMeasure = _notesPerMeasure;
@synthesize isSelected      = _isSelected;


- (id) init {
    // SET THE DEFAULT NAME
    self.soundName = @"defaultName";
    
    // SET THE DEFAULT ARRAY TO QUARTER NOTES.
    self.sixteenthNoteArray = [BeatBoxSoundRow defaultArray];
//    self.sixteenthNoteArray = [[NSMutableArray alloc] initWithObjects:
//                               0,0,0,0,
//                               0,0,0,0,
//                               0,0,0,0,
//                               0,0,0,0,nil]; //[BeatBoxSoundRow defaultArray];
    
    // SET THE DEFAULT VOLUME
    self.volume = 1.0;
    
    self.notesPerMeasure = 16;
    self.isSelected = YES;
    
    return self;
}

- (id)initWithUrl:(NSURL*)url {
//    NSRange range = [url.description rangeOfString:[url.description stringByDeletingLastPathComponent]];
    
    self.soundFilePath = [url.description stringByReplacingOccurrencesOfString:[url.description stringByDeletingLastPathComponent] withString:@""];

    self.soundName = [self.soundName stringByDeletingPathExtension];
    self.sixteenthNoteArray = [BeatBoxSoundRow defaultArray];
    self.volume = 1.0;
    self.notesPerMeasure = 16;
    self.isSelected = YES;
    
    return self;
}

- (id)initWithPath:(NSString *)path {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+" options:0 error:nil];
    
    NSRange range = [regex rangeOfFirstMatchInString:path options:0 range:NSMakeRange(0, [path length])];

    self.soundFilePath = path;
    self.soundName = [path substringWithRange:range];
    self.sixteenthNoteArray = [BeatBoxSoundRow defaultArray];
    self.volume = 1.0;
    self.notesPerMeasure = 16;
    self.isSelected = YES;
    
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
    self.notesPerMeasure = 16;
    self.isSelected = YES;
    
    return self;
}

+ (NSMutableArray*) defaultArray {
    NSMutableArray* temp = [[NSMutableArray alloc] initWithObjects:
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:0],[NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:0],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],[NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:0],[NSNumber numberWithInt:0],
                            nil];
    return temp;
}


- (BOOL)toggleElementAt:(NSInteger)index {
    BOOL updatedNoteValue = YES;
    BOOL current = [[self.sixteenthNoteArray objectAtIndex:index] boolValue];
    NSLog(@"Current BOOL value: %@", [NSNumber numberWithBool:current]);
    if (current == YES) {
        updatedNoteValue = NO;
    }
    NSLog(@"New BOOL value: %@", [NSNumber numberWithBool:updatedNoteValue]);
    [self.sixteenthNoteArray setObject:[NSNumber numberWithBool:updatedNoteValue] atIndexedSubscript:index];
    return !updatedNoteValue;
}


@end
