//
//  DCGuildFolder.h
//  Discord Classic
//
//  Created by plx on 7/13/25.
//  Copyright (c) 2025 plzdonthaxme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCGuildFolder : NSObject 

@property NSString *name;
@property int color;
@property int id;
@property NSString *firstGuildId;
@property BOOL opened;

@end