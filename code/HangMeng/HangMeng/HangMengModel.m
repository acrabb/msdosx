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

@synthesize words = _words;

//-(id) init {
//    
//}

-(NSString*)getRandomWord {
    return [_words getWord];
}

@end
