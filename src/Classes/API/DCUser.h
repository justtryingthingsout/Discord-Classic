//
//  DCUser.h
//  Discord Classic
//
//  Created by Trevir on 11/17/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/NSObjCRuntime.h>
#include <UIKit/UIKit.h>

@interface DCUser : NSObject
@property (strong, nonatomic) NSString* snowflake;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* globalName;
@property (strong, nonatomic) NSString* biography;
@property (strong, nonatomic) NSString* customStatus;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* avatarID;
@property (strong, nonatomic) NSString* avatarDecorationID;
@property (strong, nonatomic) UIImage* profileImage;
@property (strong, nonatomic) UIImage* profileBanner;
@property (assign, nonatomic) NSInteger discriminator;
@property (strong, nonatomic) UIImage* avatarDecoration;

+ (NSArray*)defaultAvatars;
- (NSString*)description;
@end
