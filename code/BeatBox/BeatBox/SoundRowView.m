//
//  SoundRowView.m
//  BeatBox
//
//  Created by André Crabb on 11/9/12.
//  Copyright (c) 2012 André Crabb. All rights reserved.
//

#import "SoundRowView.h"
#import "BeatBoxViewController.h"

@implementation SoundRowView

//@synthesize soundFilePath   = _soundFilePath;
@synthesize sound           = _sound;
@synthesize soundButton     = _soundButton;
@synthesize viewController  = _viewController;
@synthesize isActivated     = _isActivated;

@synthesize noteButtonArray       = _noteButtonArray;
//@synthesize volumeSlider    = _volumeSlider;
//@synthesize sound           = _sound;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"INIT THE SoundRowView");
        self.sound = [[BeatBoxSoundRow alloc] init];
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [self makeAndAddSoundButton];
        [self makeAndAddNoteButtons];
        
//        [self.pickerView setFrame:CGRectMake(0.0f, 300.0f, 480.0f, 300.0f)];
        // Set Label name
        // Set button selection states
    }
    return self;
}

//- (void) setViewController:(BeatBoxViewController *)viewController {
//    self.viewController = viewController;
//}

- (void) makeAndAddSoundButton {
    self.soundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.soundButton setFrame:CGRectMake(16.0f, 2.0f, 71.0f, 28.0f)];
    [self.soundButton setTitle:@"Sound" forState:UIControlStateNormal];
    //        [self.soundButton.titleLabel toggleBoldface:self.soundButton.titleLabel];
    NSLog(@"view Controller %@", self.viewController);
    [self.soundButton addTarget:self
                         action:@selector(soundButtonPushed:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.soundButton];
}

- (void) makeAndAddNoteButtons {
    int xVal = 95;
    int yVal = 6;
    int WIDTH = 22;
    int space = 1;
    for(int i=0; i<16; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        space = ((i%4) == 3) ? 5 : 1;
        
        [self setNoteButtonColorFor:button atIndex:i];
//        [button setBackgroundColor:[UIColor blueColor]];
        [button setFrame:CGRectMake(xVal, yVal, WIDTH, WIDTH)];
        [button.titleLabel setText:[NSString stringWithFormat:@"%d", i]];
        [button addTarget:self
                   action:@selector(noteButtonPushed:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.noteButtonArray addObject:button];
        [self addSubview:button];
        
        xVal += WIDTH + space;
    }
}


- (void)soundButtonPushed:(UIButton*)sender {
    NSLog(@">>> Sound button pushed!");
    NSLog(@">>> My viewController %@", self.viewController.description);
    [self.viewController soundNameButtonPushed:sender];
}

- (void)noteButtonPushed:(UIButton*)sender {
    NSLog(@">>> Note button pushed!");
    int i = [sender.titleLabel.text intValue];
    [self setNoteButtonColorFor:sender atIndex:i];
    
}

- (void)setNoteButtonColorFor:(UIButton*)button atIndex:(NSInteger)index {
    NSLog(@">>> Changing button %d", index);
    BOOL temp = [self.sound toggleElementAt:index];
    NSLog(@">>> OLD value %@", [NSNumber numberWithBool:temp]);
    if(temp) {
        NSLog(@">>> >>> Old value YES");
        [button setBackgroundColor:[UIColor blueColor]];
    } else {
        NSLog(@">>> >>> Old value NO");
        [button setBackgroundColor:[UIColor yellowColor]];
    }
}

- (void)updateButtons {
    [self.soundButton.titleLabel setText:self.sound.soundName];
    
    for(id subview in [self subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            // Do stuff!
            NSLog(@"Updating buttons!!");
//            if (subview) {
//                statements
//            }
        }
    }
    
//    NSString *soundName;
//    
//    // find the UILabel in the parent view (sound's view)
//    for (id subview in row.subviews) {
//        if ([subview isKindOfClass:[UILabel class]]) {
//            soundName = [subview text];
//            break;
//        }
//    }
    
    
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
