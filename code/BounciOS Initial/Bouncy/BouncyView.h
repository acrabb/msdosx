    //
    //  BouncyView.h
    //  Bouncy
    //
    //  Created by Glenn Sugden on 2011.08.02.
    //  Copyright 2011 UC:Berkeley. All rights reserved.
    //

#import <Cocoa/Cocoa.h>

@class BouncyViewController;

@interface BouncyView : NSView
{
@private
    BouncyViewController* _ourViewController;
}
@property (retain) IBOutlet BouncyViewController* _ourViewController;
@end
