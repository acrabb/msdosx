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
    IBOutlet UIImageView* imageView;
}

@property (retain) HangmanWords* words;

-(NSString*)getRandomWord;

@end
