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
{

}

@property (retain) HangmanWords* words;
@property (retain) NSMutableArray* guessedChars;
@property (retain) NSMutableCharacterSet* wordChars;
@property (retain) NSString* target;

-(NSString*) getRandomWord;
-(NSString*) getFilledString:(NSString*)target;
-(BOOL) guessChar:(char) c;
-(void) startNewGame;
-(BOOL) checkGameState;
-(NSString*) generateDisplayString;

@end
