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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    label = [[UILabel alloc] init];
    [_myLabel setText:@"HelloWorld!"];
//
    NSBundle* bundle = [NSBundle mainBundle];
    [_myImageView setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Hangman14" ofType:@".gif" inDirectory:@"hangmanImages1"]]];
//
//                         
//    NSLog(@"ACACAC %@", imageView);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)askModelForRandomWord {
    return [_myModel getRandomWord];
}

@end
