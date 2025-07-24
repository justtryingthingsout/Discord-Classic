//
//  DCCInfoViewController.h
//  Discord Classic
//
//  Created by XML on 12/11/23.
//  Copyright (c) 2023 bag.xml. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLSlideMenuViewController.h"
#import "DCChatViewController.h"
#import "DCContactViewController.h"
#import "DCRecipientTableCell.h"
#import "DCServerCommunicator.h"
#import "DCTools.h"
#import "DCUser.h"
@interface DCCInfoViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray* recipients;
@property (strong, nonatomic) DCUser* selectedUser;

@property (strong, nonatomic) DCUser* user;
@end
