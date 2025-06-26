//
//  DCContactViewController.h
//  Discord Classic
//
//  Created by bag.xml on 27/01/24.
//  Copyright (c) 2024 bag.xml. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCUser.h"
#import "DCTools.h"
#import "DCServerCommunicator.h"
#import "UIColorHex.h"
#import "DCMutualFriendsViewController.h"
#import "DCConnectedAccountsCell.h"
#import "APLSlideMenuViewController.h"
@interface ODCContactViewController : UITableViewController

-(void)setSelectedUser:(DCUser*)user;

@property (weak, nonatomic) IBOutlet UILabel *pronounLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *mutualFriendsButton;

@property bool noConnections;
@property NSString* snowflake;
@property NSDictionary* connectedAccounts;
@property NSDictionary* mutualFriends;
@property NSDictionary* mutualGuilds;
@end
