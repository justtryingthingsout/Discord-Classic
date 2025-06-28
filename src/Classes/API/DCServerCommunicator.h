//
//  DCServerCommunicator.h
//  Discord Classic
//
//  Created by bag.xml on 3/4/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCChannelListViewController.h"
#import "DCChatViewController.h"
#import "DCGuildListViewController.h"
#import "WSWebSocket.h"

#define DISPATCH 0
#define HEARTBEAT 1
#define IDENTIFY 2
#define PRESENCE_UPDATE 3
#define VOICE_STATE_UPDATE 4
#define UNKNOWN 5
#define RESUME 6
#define RECONNECT 7
#define GUILD_MEMBER_REQUEST 8
#define INVALID_SESSION 9
#define HELLO 10
#define HEARTBEAT_ACK 11
#define GUILD_SYNC 12
#define PRIVATE_CHANNEL_SUBSCRIBE 13
#define GUILD_SUBSCRIBE 14

@interface DCServerCommunicator : NSObject

@property WSWebSocket* websocket;
@property NSString* token;
@property NSDictionary* currentUserInfo;
@property NSString* gatewayURL;
@property NSMutableDictionary* userChannelSettings;

@property NSString* snowflake;

@property NSMutableArray* guilds;
@property bool guildsIsSorted;
@property NSMutableDictionary* channels;
@property NSMutableDictionary* loadedUsers;
@property NSMutableDictionary* loadedRoles;

@property DCGuild* selectedGuild;
@property DCChannel* selectedChannel;

@property bool didAuthenticate;

+ (DCServerCommunicator*)sharedInstance;
- (void)startCommunicator;
- (void)sendResume;
- (void)reconnect;
- (void)sendHeartbeat:(NSTimer*)timer;
- (void)sendJSON:(NSDictionary*)dictionary;
@end
