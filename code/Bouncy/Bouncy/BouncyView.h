//
//  BouncyView.h
//  Bouncy
//
//  Created by Amir Khodaei on 9/19/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BouncyViewController;

@interface BouncyView : NSView
{
    //@private
    BouncyViewController* _ourViewController;
}

@property (assign) IBOutlet BouncyViewController* ourViewController;

@end
