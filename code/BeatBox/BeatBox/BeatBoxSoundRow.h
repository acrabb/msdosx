//
//  BeatBoxSoundRow.h
//  BeatBox
//
//  Created by André Crabb on 11/7/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeatBoxSoundRow : NSObject

// Sound file path
// Sound name
// BOOL array
// Overall volume
//

@property NSString*         soundFilePath;
@property NSString*         soundName;
@property NSMutableArray*   sixteenthNoteArray;
@property float             volume;


- (id) init;
- (id) initWithName:(NSString*)         name
              array:(NSMutableArray*)   array
             volume:(float)             volume
           filePath:(NSString*)         filePath;
+ (NSMutableArray*) defaultArray;

@end
