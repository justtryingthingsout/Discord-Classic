//
//  DCMutualFriendsViewController.h
//  Discord Classic
//
//  Created by XML on 04/01/25.
//  Copyright (c) 2025 bag.xml. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCUser.h"
#import "DCTools.h"
#import "DCRecipientTableCell.h"
#import "DCContactViewController.h"

@interface DCMutualFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property DCUser* user;
@property (nonatomic, strong) DCUser *selectedUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (weak, nonatomic) IBOutlet UITableView *mutTableView;

@property NSDictionary* mutualFriendsList;
@property NSMutableArray* recipients;
@end
