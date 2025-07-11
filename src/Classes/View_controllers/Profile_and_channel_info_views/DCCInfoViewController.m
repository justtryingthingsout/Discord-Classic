//
//  DCCInfoViewController.m
//  Discord Classic
//
//  Created by XML on 12/11/23.
//  Copyright (c) 2023 bag.xml. All rights reserved.
//

#import "DCCInfoViewController.h"
#include <dispatch/dispatch.h>
#include "DCRole.h"
#include <Foundation/Foundation.h>

@interface DCCInfoViewController ()

@end

@implementation DCCInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNotificationCenter.defaultCenter
            addObserver:self
               selector:@selector(guildMemberListUpdated:)
                   name:@"GuildMemberListUpdated"
                 object:nil];
    self.recipients = [NSMutableArray array];
    if (DCServerCommunicator.sharedInstance.selectedChannel && [DCServerCommunicator.sharedInstance.selectedChannel.parentGuild.snowflake length] > 0) {
        // If a guild is selected, get the members from the guild
        self.title = [DCServerCommunicator.sharedInstance.selectedChannel.parentGuild name];
        self.navigationItem.title = self.title;
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Members"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showMembers)];
#ifdef DEBUG
        NSLog(@"Selected channel: #%@ in guild: %@", [DCServerCommunicator.sharedInstance.selectedChannel name], [DCServerCommunicator.sharedInstance.selectedChannel.parentGuild name]);
#endif
        NSArray *members = [[DCServerCommunicator.sharedInstance.selectedChannel.parentGuild members] copy];
        for (id member in members) {
            [self.recipients addObject:member];
        }
    } else if (DCServerCommunicator.sharedInstance.selectedChannel) {
#ifdef DEBUG
        NSLog(@"Selected channel: %@", DCServerCommunicator.sharedInstance.selectedChannel.name);
#endif
        NSArray *recipientDictionaries = [DCServerCommunicator.sharedInstance.selectedChannel recipients];
        for (NSDictionary *recipient in recipientDictionaries) {
            DCUser *dcUser = [DCTools convertJsonUser:recipient cache:YES];
            //NSLog(@"Adding recipient: %@", dcUser.username);
            [self.recipients addObject:dcUser];
        }
    } else {
#ifdef DEBUG
        NSLog(@"No channel or guild selected!");
#endif
    }
}

- (void)guildMemberListUpdated:(NSNotification *)notification {
    // Update the recipients list when the guild member list is updated
#ifdef DEBUG
    NSLog(@"Guild member list updated notification received.");
#endif
    if (!DCServerCommunicator.sharedInstance.selectedChannel 
    || [DCServerCommunicator.sharedInstance.selectedChannel.parentGuild.snowflake length] <= 0) {
        return;
    }
    self.recipients = [[DCServerCommunicator.sharedInstance.selectedChannel.parentGuild members] copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if (DCServerCommunicator.sharedInstance.selectedChannel) {
        //NSLog(@"Returning count of recipients: %lu", (unsigned long)[self.recipients count]);
        return [self.recipients count];
    } else {
#ifdef DEBUG
        NSLog(@"No channel or guild selected!");
#endif
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hackyMode"]) {
        id item                              = self.recipients[indexPath.row];
        DCRecipientTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Members cell"];
        if ([item isKindOfClass:[DCUser class]]) {
            DCUser *user = item;
            cell.userName.text               = user.globalName;
            cell.userPFP.image               = user.profileImage;
            cell.userPFP.layer.cornerRadius  = cell.userPFP.frame.size.width / 2.0;
            cell.userPFP.layer.masksToBounds = YES;
        } else if ([item isKindOfClass:[DCRole class]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Roles Cell"];
            if (cell == nil) {
               cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:@"Roles Cell"];
               // make unclickable
               [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
               [cell setUserInteractionEnabled:NO];
               [cell.textLabel setEnabled:NO];
               [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
               [cell.detailTextLabel setEnabled:NO];
               [cell setAlpha:0.5];
               [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            DCRole *role = item;
            [cell.textLabel setText:role.name];
            return cell;
        } else {
#ifdef DEBUG
            NSLog(@"Unknown item type in recipients: %@", [item class]);
#endif
            cell.textLabel.text = @"Unknown";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = @"Unknown";
        }
        return cell;
    } else {
        UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"Members Cell"];
        if (!cell) {
            cell = UITableViewCell.new;
        }
        id item        = self.recipients[indexPath.row];
        if ([item isKindOfClass:[DCUser class]]) {
            DCUser *user = (DCUser *)item;
            cell.textLabel.text = user.username;
        } else if ([item isKindOfClass:[DCRole class]]) {
            DCRole *role = (DCRole *)item;
            cell.textLabel.text = role.name;
        } else {
            cell.textLabel.text = @"Unknown";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        id item = self.recipients[indexPath.row];
        if ([item isKindOfClass:[DCRole class]]) {
            return 20.0;
        }
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedUser = self.recipients[indexPath.row];
    [self performSegueWithIdentifier:@"channelinfo to contact" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController
            isKindOfClass:[DCContactViewController class]]) {
        DCContactViewController *contactVC =
            (DCContactViewController *)segue.destinationViewController;
        contactVC.selectedUser = self.selectedUser;
    }
}

@end
