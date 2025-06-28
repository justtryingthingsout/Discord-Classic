//
//  DCGuild.h
//  Discord Classic
//
//  Created by bag.xml on 3/12/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

/*DCGuild is a representation of a Discord API Guild object.
 Its easier to work with than raw JSON data and has some handy
 built in functions*/

#import <Foundation/Foundation.h>

@interface DCGuild : NSObject
// ID/snowflake
@property NSString* snowflake;
// Name
@property NSString* name;
@property NSString* ownerID;
@property int* memberCount;

@property UIImage* icon;
@property UIImage* banner;


// Array of child DCCannel objects
@property NSMutableArray* channels;
// Whether or not the guild has any unread child channels
@property bool unread;

@property NSMutableDictionary* members;
@property NSMutableDictionary* roles;
@property NSMutableArray* userRoles;

- (void)checkIfRead;
@end
