//
//  HangMengModel.m
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import "HangMengModel.h"
#import "HangmanWords.h"

@implementation HangMengModel

const char DEFAULT = '-';
const char SPACE = ' ';

@synthesize words = _words;
@synthesize guessedChars = _guessedChars;
@synthesize wordChars = _wordChars;
@synthesize target = _target;


-(id) init {
    _words = [[HangmanWords alloc] init];
    _guessedChars = [[NSMutableArray alloc] init];
    _wordChars = [[NSMutableCharacterSet alloc] init];
    [_wordChars removeCharactersInRange:NSMakeRange(SPACE, 1)];
    [self startNewGame];
    
    return self;
}

-(void) startNewGame
{
    _target = [self getRandomWord];
    
    [_wordChars addCharactersInString:_target];
    NSLog(@">> Target word is %@", _target);

    // Generate the displayString
    // Tell controller to set image, displayString, and keys.
}

-(BOOL)guessChar:(char) c
{
    //DO SOME STUFF
    // THEN...
    NSLog(@">> Guessing char %hhd...", c);
    [_wordChars removeCharactersInRange:NSMakeRange(c, 0)];
    [_guessedChars addObject:[NSNumber numberWithChar:c]];
    NSLog(@"ACACAC _guessedChars: %@. _wordChars: %@", _guessedChars.description, _wordChars.description);
    return NO;
    
}

    /*/
     -(NSString*)getFilledString:(NSString*) target
{
//    NSMutableString *retVal = [[NSMutableString alloc];
     unichar c;
    for (int i=0; i<target.length; i++) {
//        NSLog(@"ACAC OH HI THERE");
        c = [target characterAtIndex:i];
        if ([_wordChars containsObject:c]) {
            //TODO
            [retVal appendString:@"-"];
            
        } else {
            [retVal appendString:[NSString stringWithCharacters:c length:1]];
        }
    }
     
//    NSLog(@"ACACAC retVal: %@", retVal);
    
    // Given the target string, return a string whose characters are identical to target, but with "-"s instead of letters, except for those in 'guessedChars'.
    
//    return retVal;
    
}
/**/


-(NSString*)getRandomWord {
    return [_words getWord];
}

@end
