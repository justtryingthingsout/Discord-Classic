//
//  DCChannel.h
//  Discord Classic
//
//  Created by bag.xml on 3/12/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

/*DCChannel is a representation of a Discord API Channel object.
 Its easier to work with than raw JSON data and has some handy
 built in functions*/

#import <Foundation/Foundation.h>
#import "DCGuild.h"
#import "DCMessage.h"

@interface DCChannel : NSObject<NSURLConnectionDelegate>
@property (strong, nonatomic) NSString* snowflake;
// parent category (for channels) or id of text channel (for threads)
@property (strong, nonatomic) NSString* parentID; 
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* lastMessageId;
@property (strong, nonatomic) NSString* lastReadMessageId;
// Icon for a DM
@property (strong, nonatomic) UIImage* icon; 
@property (assign, nonatomic) BOOL unread;
@property (assign, nonatomic) BOOL muted;
@property (assign, nonatomic) BOOL writeable;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger position;
// Holds NSDictionary* of Users
@property (strong, nonatomic) NSMutableArray* recipients;
@property (weak, nonatomic) DCGuild* parentGuild;
// Holds NSDictionary* of Users
@property (strong, nonatomic) NSArray* users;

- (void)checkIfRead;
- (void)sendTypingIndicator;
- (void)sendMessage:(NSString*)message;
- (void)ackMessage:(NSString*)message;
- (void)sendImage:(UIImage*)image mimeType:(NSString*)type;
- (void)sendData:(NSData*)data mimeType:(NSString*)type;
- (void)sendVideo:(NSURL*)videoURL mimeType:(NSString*)type;
- (NSArray*)getMessages:(int)numberOfMessages beforeMessage:(DCMessage*)message;
@end
