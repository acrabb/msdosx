//
//  HangMengView.m
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import "HangMengView.h"

@implementation HangMengView

@synthesize myController = _myController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//       NSLog(@"ACACAC x:%f, y:%f, w:%f, h:%f", rect.origin.x, rect.origin.y,
//                rect.size.width, rect.size.height);
//    NSArray* sv = self.subviews;
//    UILabel* lab = [sv objectAtIndex:1];
//    lab.text = @"This is text.";
//    [lab setText:@"hello"];
}
/**/

@end
