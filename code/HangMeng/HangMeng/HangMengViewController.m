//
//  HangMengViewController.m
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import "HangMengViewController.h"

@interface HangMengViewController ()

@end

@implementation HangMengViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    label = [[UILabel alloc] init];
    [label setText:@"HelloWorld!"];
    
    [imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Hangman14.gif" ofType:@".gif" inDirectory:@"hangmanImages1"]]];
                         
                         
    NSLog(@"ACACAC %@", imageView);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
