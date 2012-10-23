//
//  NotesMasterViewController.h
//  Notes
//
//  Created by Class Account on 10/22/12.
//  Copyright (c) 2012 Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesDetailViewController;

@interface NotesMasterViewController : UITableViewController

@property (strong, nonatomic) NotesDetailViewController *detailViewController;

@end
