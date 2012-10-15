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

@implementation HangMengViewController

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
    
    NSString* word = [self askModelForRandomWord];
    [_myLabel setText:word];

    
    // THIS DIDN'T WORK
//    NSBundle* bundle = [NSBundle mainBundle];
//    [_myImageView setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Hangman14" ofType:@".gif" inDirectory:@"hangmanImages1"]]];
    
    _myImageView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Hangman14" ofType:@"gif"]];

    [self tellModelGuessedChar:'a'];
    [self tellModelGuessedChar:'e'];
    [self tellModelGuessedChar:'i'];
    
//    NSString* val = [_myModel getFilledString:word];
    
//    NSLog(@"ACACAC val is: %@", val);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString*)askModelForRandomWord {
    return [_myModel getRandomWord];
}

- (void) tellModelGuessedChar:(char) c {
    [_myModel guessChar:c];
}


@end
