//
//  BeatBoxLightBulbView.m
//  BeatBox
//
//  Created by Amir Khodaei on 11/21/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxLightBulbView.h"

@implementation BeatBoxLightBulbView

- (id)initWithFrame:(CGRect)frame andController:(BeatBoxViewController *)vc {
    self = [super initWithFrame:frame];
    self.viewController = vc;
    [self addLightBulbs];
    return self;
}

- (void) addLightBulbs {
    
    int xVal = 95;
    int yVal = 6;
    int WIDTH = 22;
    int space = 1;
    
    for(int i=0; i<16; i++) {

        UIImageView *bulbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xVal, yVal, WIDTH, WIDTH)];
        
        space = ((i%4) == 3) ? 5 : 1;
        
        [bulbImageView setImage:[UIImage imageNamed:@"led-circle-grey-md.png"]];
        [bulbImageView setTag:i+1];
        
        //[self.lightBulbs addObject:bulbImageView];
        [self addSubview:bulbImageView];
        
        xVal += WIDTH + space;
    }
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
