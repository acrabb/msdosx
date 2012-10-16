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

NSString* UNDERSCORE = @"_";
NSString* SPACE = @" ";

@synthesize words = _words;
@synthesize guessedChars = _guessedChars;
@synthesize wordChars = _wordChars;
@synthesize target = _target;
@synthesize stringDidChange = _stringDidChange;


-(id) init {
    _words = [HangmanWords alloc];
    _guessedChars = [NSMutableArray alloc];
    _wordChars = [NSMutableSet alloc];
    [self startNewGame];
    
    return self;
}

-(void) startNewGame
{
    _words = [_words init];
    _guessedChars = [_guessedChars init];
    _wordChars = [_wordChars init];
    
    // Get the word to be guessed.
    _target = [self getRandomWord];
    
    // Put all characters in a set.
    NSString* charStr;
    for (NSInteger i=0; i<_target.length; i++) {
        charStr = [NSString stringWithFormat:@"%c", [_target characterAtIndex:i]];
        if(![charStr isEqual:SPACE])
        {
            [_wordChars addObject:charStr];
        }
    }
 
    NSLog(@">> Target word is %@", _target);
    NSLog(@">> Character Set: %@", _wordChars);
    
    // Tell controller to set image, displayString, and keys.
}

-(BOOL)guessChar:(NSString*) c
{
    _stringDidChange = NO;
    
    c = [c uppercaseString];
    NSLog(@">> Guessing char %@...", c);
    if ([_wordChars containsObject:c])
    {
        [_wordChars removeObject:c];
        NSLog(@">> Character %@ is in %@!!", c, _target);
        _stringDidChange = YES;
    }
    else
    {
        NSLog(@">> Character %@ is not in %@.", c, _target);
    }
    [_guessedChars addObject:c];
    NSLog(@"ACACAC _guessedChars: %@. _wordChars: %@", _guessedChars.description, _wordChars.description);
    return NO;
    
}

    /**/
-(NSString*)getFilledString
{
    NSMutableString *retVal = [[NSMutableString alloc] init];
    NSString* c;
    for (NSInteger i=0; i<_target.length; i++) {
        c = [NSString stringWithFormat:@"%c", [_target characterAtIndex:i]];
        if ([_wordChars containsObject:c]) {
            [retVal appendString:UNDERSCORE];
        } else {
            [retVal appendString:c];
        }
    }
     
    NSLog(@"ACACAC Dashed retVal: %@", retVal);
    
    // Given the target string, return a string whose characters are identical to target, but with "-"s instead of letters, except for those in 'guessedChars'.
    
    return retVal;
    
}
/**/


-(NSString*)getRandomWord {
    return [_words getWord];
}

@end
