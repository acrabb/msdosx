//
//  SoundRowView.h
//  BeatBox
//
//  Created by André Crabb on 11/9/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeatBoxSoundRow.h"
@class BeatBoxViewController;

@interface SoundRowView : UIView

@property UIButton                          *soundButton;
@property NSMutableArray                    *noteButtonArray;
@property IBOutlet BeatBoxViewController    *viewController;

- (id) initWithFrame:(CGRect)frame andController:(BeatBoxViewController*)vc;

- (void) setSoundButtonLabel:(NSString*)soundName;
- (void) setNoteButtonColor:(NSInteger)index;
//- (IBAction)soundButtonPushed:(UIButton*)sender;

@end
