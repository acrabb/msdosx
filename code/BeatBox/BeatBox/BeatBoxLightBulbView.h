//
//  BeatBoxLightBulbView.h
//  BeatBox
//
//  Created by Amir Khodaei on 11/21/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeatBoxViewController;

@interface BeatBoxLightBulbView : UIView

@property NSMutableArray                    *lightBulbs;
@property IBOutlet BeatBoxViewController    *viewController;

- (id) initWithFrame:(CGRect)frame andController:(BeatBoxViewController*)vc;

@end
