//
//  DCMessage.h
//  Discord Classic
//
//  Created by bag.xml on 4/6/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#import "DCUser.h"

typedef NS_ENUM(NSInteger, message_types) {
    DEFAULT                                      = 0,
    RECIPIENT_ADD                                = 1,
    RECIPIENT_REMOVE                             = 2,
    CALL                                         = 3,
    CHANNEL_NAME_CHANGE                          = 4,
    CHANNEL_ICON_CHANGE                          = 5,
    CHANNEL_PINNED_MESSAGE                       = 6,
    USER_JOIN                                    = 7,
    GUILD_BOOST                                  = 8,
    GUILD_BOOST_TIER_1                           = 9,
    GUILD_BOOST_TIER_2                           = 10,
    GUILD_BOOST_TIER_3                           = 11,
    CHANNEL_FOLLOW_ADD                           = 12,
    GUILD_DISCOVERY_DISQUALIFIED                 = 14,
    GUILD_DISCOVERY_REQUALIFIED                  = 15,
    GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING = 16,
    GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING   = 17,
    THREAD_CREATED                               = 18,
    REPLY                                        = 19,
    CHAT_INPUT_COMMAND                           = 20,
    THREAD_STARTER_MESSAGE                       = 21,
    GUILD_INVITE_REMINDER                        = 22,
    CONTEXT_MENU_COMMAND                         = 23,
    AUTO_MODERATION_ACTION                       = 24,
    ROLE_SUBSCRIPTION_PURCHASE                   = 25,
    INTERACTION_PREMIUM_UPSELL                   = 26,
    STAGE_START                                  = 27,
    STAGE_END                                    = 28,
    STAGE_SPEAKER                                = 29,
    STAGE_TOPIC                                  = 31,
    GUILD_APPLICATION_PREMIUM_SUBSCRIPTION       = 32,
    GUILD_INCIDENT_ALERT_MODE_ENABLED            = 36,
    GUILD_INCIDENT_ALERT_MODE_DISABLED           = 37,
    GUILD_INCIDENT_REPORT_RAID                   = 38,
    GUILD_INCIDENT_REPORT_FALSE_ALARM            = 39,
    PURCHASE_NOTIFICATION                        = 44,
    POLL_RESULT                                  = 46,
};

@interface DCMessage : NSObject
@property(strong, nonatomic) NSString* snowflake;
@property(strong, nonatomic) DCUser* author;
@property(strong, nonatomic) NSString* content;
@property(strong, nonatomic) NSAttributedString* attributedContent;
@property(assign, nonatomic) NSInteger attachmentCount;
@property(strong, nonatomic) NSMutableArray* attachments;
@property(assign, nonatomic) NSInteger contentHeight;
@property(assign, nonatomic) NSInteger authorNameWidth;
@property(strong, nonatomic) NSDate* timestamp;
@property(strong, nonatomic) NSDate* editedTimestamp;
@property(strong, nonatomic) NSString* prettyTimestamp;
@property(assign, nonatomic) BOOL pingingUser;
@property(assign, nonatomic) BOOL isGrouped;
@property(strong, nonatomic) NSString* preDefinedContent;
@property(assign, nonatomic) NSInteger messageType;
@property(strong, nonatomic) DCMessage* referencedMessage;
@property(weak, nonatomic) UITableViewCell* cell;

// embed
//@property NSString *
- (void)deleteMessage;
- (BOOL)isEqual:(id)other;
@end
