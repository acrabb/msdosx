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
    [_myLabel setText:[_myModel target]];

    
    _myImageView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Hangman14" ofType:@"gif"]];
    NSLog(@"image description: %@", [_myImageView description]);


    [_myLabel setText:[self askModelForDisplayString]];
//    [self tellModelGuessedChar:@"a"];
//    [self tellModelGuessedChar:@"e"];
//    [self tellModelGuessedChar:@"i"];
    
    [_myLabel setText:[self askModelForDisplayString]];
//    NSString* val = [_myModel getFilledString:word];
    
//    NSLog(@"ACACAC val is: %@", val);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSString*)askModelForRandomWord {
//    return [_myModel getRandomWord];
//}

- (void) tellModelGuessedChar:(NSString*) c {
    [_myModel guessChar:c];
//    [_myLabel setNeedsDisplay];
}

- (NSString *) askModelForDisplayString
{
    // TODO
    return [_myModel getFilledString];
}


- (IBAction)letterPressed:(UIButton *)sender {
    [self tellModelGuessedChar:sender.titleLabel.text];
    if( _myModel.stringDidChange)
    {
        [_myLabel setText:[self askModelForDisplayString]];
        [_myLabel setNeedsDisplay];
    }
}

- (IBAction)resetPressed:(UIButton *)sender {
    [_myModel startNewGame];
    [_myLabel setNeedsDisplay];
}
@end
