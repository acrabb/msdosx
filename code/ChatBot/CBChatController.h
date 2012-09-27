//
//  CBChatController.h
//  ChatBot
//
//  Created by Ian Henderson on 01.27.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CBChatBot;

@interface CBChatController : NSObject {
  IBOutlet NSTextView *chatView;
  
  CBChatBot *bot;
}

- (void)appendMessage:(NSString *)messageString fromScreenName:(NSString *)screenName withColor:(NSColor *)color;
- (IBAction)sendMessage:(id)sender;

@end
