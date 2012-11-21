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


@synthesize soundButton     = _soundButton;
@synthesize viewController  = _viewController;

@synthesize noteButtonArray       = _noteButtonArray;


- (id) initWithFrame:(CGRect)frame andController:(BeatBoxViewController*)vc {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"INIT THE SoundRowView");
        self.viewController = vc;
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [self makeAndAddSoundButton];
        [self makeAndAddNoteButtons];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
       andController:(BeatBoxViewController*)vc
            andSound:(BeatBoxSoundRow*)sound {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"INIT THE SoundRowView");
        self.viewController = vc;
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
        [self makeAndAddSoundButton];
        [self makeAndAddNoteButtons];
        [self.viewController linkSound:sound withView:self];
    }
    return self;
}

- (void) makeAndAddSoundButton {
    self.soundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.soundButton setFrame:CGRectMake(16.0f, 2.0f, 71.0f, 28.0f)];
    [self.soundButton setTitle:@"Sound" forState:UIControlStateNormal];

    NSLog(@"view Controller %@", self.viewController);
    [self.soundButton addTarget:self.viewController
                         action:@selector(soundNameButtonPushed:)
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
        
//        [self setNoteButtonColorFor:button atIndex:i];
//        [button setBackgroundColor:[UIColor blueColor]];
        
        [button setFrame:CGRectMake(xVal, yVal, WIDTH, WIDTH)];
        [button.titleLabel setText:[NSString stringWithFormat:@"%d", i]];
        
        [button addTarget:self.viewController
                   action:@selector(noteButtonPushed:)
         forControlEvents:UIControlEventTouchUpInside];

        [button setImage:[UIImage imageNamed:@"note_button_pushed.png"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"note_button_not_pushed.png"] forState:UIControlStateNormal];
         
        [self.noteButtonArray addObject:button];
        [self addSubview:button];
        
        xVal += WIDTH + space;
    }
}

/*
 * Update the soundButton label with the sound name
 * Apply the (saved!) noteArray of the new sound to the note button in the view
 */
- (void) setSoundButtonLabel:(NSString*)soundName {
    [self.soundButton setTitle:soundName forState:UIControlStateNormal];
}

/*
- (void)noteButtonPushed:(UIButton*)sender {
    NSLog(@">>> Note button pushed!");
    int i = [sender.titleLabel.text intValue];
    [self setNoteButtonColorFor:sender atIndex:i];
    
}
 */

/*
- (void)setNoteButtonColorFor:(UIButton*)button atIndex:(NSInteger)index {
    NSLog(@">>> Changing button %d", index);
//    BOOL temp = [self.sound toggleElementAt:index];
//    NSLog(@">>> OLD value %@", [NSNumber numberWithBool:temp]);
    // if(temp) {
    if (button.selected)
        NSLog(@">>> >>> Old value YES");
        [button setBackgroundColor:[UIColor blueColor]];
    } else {
        NSLog(@">>> >>> Old value NO");
        [button setBackgroundColor:[UIColor yellowColor]];
    }
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
