//
//  NotesDetailViewController.h
//  Notes
//
//  Created by Class Account on 10/22/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
