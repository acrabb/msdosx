//
//  HangMengViewController.m
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import "HangMengViewController.h"

//@interface HangMengViewController ()
//
//@end

/*
    All images are .gif format.
    Base image: Hangman0.gif
    Last image: Hangman14.gif
 
 */
@implementation HangMengViewController


NSString *_baseImage = @"Hangman0";
NSString *_currentImage;
@synthesize myModel = _myModel;
@synthesize myView = _myView;
@synthesize myLabel = _myLabel;
@synthesize myImageView = _myImageView;


- (void)awakeFromNib
{
    //didn't get called on boot?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _myModel = [[HangMengModel alloc] init];
    [_myModel startNewGame];
    
    [self setHangmanImage:_baseImage];
    
    [_myLabel setText:[self askModelForDisplayString]];
//    [self setHangmanImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) tellModelGuessedChar:(NSString*) c {
    [_myModel guessChar:c];
    [self checkGameState];
}

-(void) checkGameState {
    // Update image, text, and anything else.
    if( _myModel.stringDidChange)
    {
        [_myLabel setText:[self askModelForDisplayString]];
    } else // Update the image
    {
        _currentImage = [NSString stringWithFormat:@"Hangman%d", [_myModel numMissedGuesses]];
        NSLog(@"ACACAC Setting the current image to %@", _currentImage);
        [self setHangmanImage:_currentImage];
    }
    if ([_myModel isWin])
    {
        // Do stuff.
        NSLog(@"CONGRATULATIONS! You've correctly guessed: %@", _myModel.target);
    } else if ([_myModel isLoss])
    {
        // Do stuff.
        NSLog(@"Sorry, you didn't guess correctly this time. :(");
        
    }
}

- (NSString *) askModelForDisplayString
{
    // TODO
    return [_myModel generateDisplayString];
}

-(void) setLabelText:(NSString*) text {
    [_myLabel setText:text];

}


- (IBAction)letterPressed:(UIButton *)sender {
    if (![_myModel isGameOver]) {
        [self tellModelGuessedChar:sender.titleLabel.text];
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    // Why didn't this work?
    //    [sender.titleLabel setTextColor:[UIColor redColor]];
    [sender setUserInteractionEnabled:NO];
}

- (IBAction)resetPressed:(UIButton *)sender {
    [_myModel startNewGame];
    [_myLabel setText:[self askModelForDisplayString]];
    [self setHangmanImage:_baseImage];
    
    // Reset all buttons to user-interactive with blue text.
    for (UIView* view in [_myView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view setUserInteractionEnabled:YES];
            [view setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
}

-(void) setHangmanImage:(NSString *)image {
    _myImageView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:image ofType:@"gif"]];
}

@end
