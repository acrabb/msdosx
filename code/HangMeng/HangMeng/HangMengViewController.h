//
//  HangMengViewController.h
//  HangMeng
//
//  Created by Amir Khodaei on 10/3/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HangMengModel.h"
#import "HangMengView.h"

@interface HangMengViewController : UIViewController
{
    
}

@property (retain) HangMengModel* myModel;
@property (retain) IBOutlet HangMengView* myView;
@property (retain) IBOutlet UILabel* myLabel;
@property (retain) IBOutlet UIImageView* myImageView;
@property (retain) NSHashTable* hangmanImages;

//-(NSString*)askModelForRandomWord;
- (IBAction)letterPressed:(UIButton *)sender;
- (IBAction)resetPressed:(UIButton *)sender;
- (void) setHangmanImage:(NSString *) image;
- (void) setLabelText:(NSString *) text;
- (void) checkGameState;

@end
