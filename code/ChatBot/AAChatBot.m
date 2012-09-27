//
//  AAChatBot.m
//  ChatBot
//
//  Created by Amir Khodaei on 9/5/12.
//
//

#import "AAChatBot.h"
#import "CBChatBot.h"


@implementation AAChatBot

@synthesize rememberedString = _rememberedString;

+ (NSString *) screenName
{
    return @"NuestroBot";
}


- (void) respondToChatMessage:(NSString *)chatMessage
{    
    if([chatMessage isEqual:@"hello"])
    {
        [self sendMessage:@"hello"];
    }
    else if([chatMessage isEqual:@"date"])
    {
        [self sendMessage:[[NSDate date] description]];
    }
    else if([chatMessage hasPrefix:@"remember"])
    {
        self.rememberedString = [chatMessage retain];
    }
    else if([chatMessage isEqual:@"recall"])
    {
        [self sendMessage:self.rememberedString];
    }
    else if([chatMessage hasPrefix:@"timer"])
    {
        NSString *num = [chatMessage substringFromIndex:5];
        [NSTimer scheduledTimerWithTimeInterval:[num floatValue]
                                         target:self
                                       selector:@selector(timerTriggered:)
                                       userInfo:nil
                                        repeats:NO];
    }
    
}

- (void) timerTriggered: (NSTimer *) timer
{
    [self sendMessage:@"ding!"];
}

@end
