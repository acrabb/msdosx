//
//  SoundRowView.m
//  BeatBox
//
//  Created by André Crabb on 11/9/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "SoundRowView.h"

@implementation SoundRowView


@synthesize soundFilePath   = _soundFilePath;
@synthesize soundName       = _soundName;
@synthesize noteArray       = _noteArray;
@synthesize volumeSlider    = _volumeSlider;
@synthesize sound           = _sound;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Set Label name
        // Set button selection states
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
