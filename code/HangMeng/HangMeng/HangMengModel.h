//
//  HangMengModel.h
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HangmanWords.h"

@interface HangMengModel : NSObject


@property (retain) HangmanWords* words;
@property (retain) NSMutableArray* guessedChars;
@property (retain) NSMutableSet* wordChars;
@property (retain) NSString* target;
@property BOOL stringDidChange;
@property int numMissedGuesses;
@property const int MAX_GUESSES;

-(NSString*) getRandomWord;
-(BOOL) guessChar:(NSString*) c;
-(void) startNewGame;
-(NSString*) generateDisplayString;
-(BOOL) isWin;
-(BOOL) isLoss;
-(void) endWithWin;
-(void) endWithLoss;
-(BOOL) isGameOver;


@end
