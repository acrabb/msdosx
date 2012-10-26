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

const NSString* UNDERSCORE = @"_";
const NSString* SPACE = @" ";

@synthesize words = _words;
@synthesize guessedChars = _guessedChars;
@synthesize wordChars = _wordChars;
@synthesize target = _target;
@synthesize stringDidChange = _stringDidChange;
@synthesize numMissedGuesses = _numMissedGuesses;


-(id) init {
    _words = [[HangmanWords alloc] init];
    _guessedChars = [NSMutableArray alloc];
    _wordChars = [NSMutableSet alloc];
    _numMissedGuesses = 0;
    self.MAX_GUESSES = 14;
    
    return self;
}

/*
    Initialize new data structures.
    Get the new word to be guessed.
    Fill data structures.
    Reset numMissedGuesses to 0.
 */
-(void) startNewGame
{
    _guessedChars = [_guessedChars init];
    _wordChars = [_wordChars init];
    _numMissedGuesses = 0;
    
    // Get the word to be guessed.
    _target = [self getRandomWord];
    //_target = [_target uppercaseString];
    
    // Put all characters in a set.
    NSString* charStr;
    for (int i=0; i<_target.length; i++)
    {
        charStr = [NSString stringWithFormat:@"%c", [_target characterAtIndex:i]];
        if(![charStr isEqual:SPACE])
        {
            [_wordChars addObject:charStr];
        }
    }
 
    NSLog(@">> Target word is %@", _target);
    NSLog(@">> Character Set: %@", _wordChars);
    
    // Tell controller to set image, displayString.
}

-(BOOL)guessChar:(NSString*) c
{
    _stringDidChange = NO;
    
    c = [c uppercaseString];
    [_guessedChars addObject:c];
    
    // If the character is in the target word:
    if ([_wordChars containsObject:c])
    {
        [_wordChars removeObject:c];
        NSLog(@">> Good guess on %@!", c);
        _stringDidChange = YES;
    }
    else
    {
        _numMissedGuesses++;
        NSLog(@">> Sorry, %@ is incorrect :(", c);
    }
    
    return _stringDidChange;
}

-(NSString*)generateDisplayString
{
    NSMutableString *retVal = [[NSMutableString alloc] init];
    NSString* c;
    for (int i=0; i<_target.length; i++) {
        c = [NSString stringWithFormat:@"%c", [_target characterAtIndex:i]];
        if ([_wordChars containsObject:c]) {
            [retVal appendString:UNDERSCORE];
        } else {
            [retVal appendString:c];
        }
        [retVal appendString:SPACE];
    }
    
    NSLog(@"Take a guess: %@", retVal);
    
    return retVal;
}

-(NSString*)getRandomWord {
    return [_words getWord];
}

/*
    Check if the number of missed guesses is < MAX_GUESSES.
    Check that the number of words left to guess is 0;
 */
-(BOOL) isWin {
    return (_numMissedGuesses < self.MAX_GUESSES) && ([_wordChars count] == 0);
}

-(BOOL) isLoss {
    return (_numMissedGuesses >= self.MAX_GUESSES);
}

/*
    Update strings to a win message.
    Display target string.
    Set inPlay to false. (?)
 */
-(void) endWithWin {
    NSLog(@"Congratulations! You correctly guessed %@", _target);
}

/*
    Update strings to a loss message.
    Set inPlay to false. (?)
 */
-(void) endWithLoss {
    NSLog(@"Aww, you're out of guesses. Please try again!");
}

-(BOOL) isGameOver {
    return [self isWin] || [self isLoss];
}

-(void) dealloc
{
    [_wordChars dealloc];
    [_guessedChars dealloc];
    [_words dealloc];
    [super dealloc];
}

@end
