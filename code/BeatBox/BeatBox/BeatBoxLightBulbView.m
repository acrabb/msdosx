//
//  BeatBoxLightBulbView.m
//  BeatBox
//
//  Created by Amir Khodaei on 11/21/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "BeatBoxLightBulbView.h"

@implementation BeatBoxLightBulbView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self makeAndAddLightButtons]
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andController:(BeatBoxViewController *)vc {
    self = [super initWithFrame:frame];
    self.viewController = vc;
    [self makeAndAddLightButtons];
}

- (void) makeAndAddLightButtons {
    
    int xVal = 95;
    int yVal = 6;
    int WIDTH = 22;
    int space = 1;
    
    for(int i=0; i<16; i++) {

        UIImage *bulbLabel = [[UIImage alloc] initWithFrame:CGRectMake(xVal, yVal, WIDTH, WIDTH)];
        
        space = ((i%4) == 3) ? 5 : 1;
        
//        [bulbLabel setFrame:CGRectMake(xVal, yVal, WIDTH, WIDTH)];
        [bulbLabel setText:[NSString stringWithFormat:@"%d", i]];
        
//        [button addTarget:self
//                   action:@selector(self.viewController noteButtonPushed:)
//         forControlEvents:UIControlEventTouchUpInside];
        [bulbLabel ]
        [bulbLabel setImage:[UIImage imageNamed:@"led-circle-grey-md.png"] forState:UIControlStateNormal];
        
//        [button setImage:[UIImage imageNamed:@"note_button_pushed.png"] forState:UIControlStateSelected];
        
        [self.lightBulbs addObject:button];
        [self addSubview:button];
        
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
