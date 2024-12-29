//
//  DCContactViewController.m
//  Discord Classic
//
//  Created by bag.xml on 27/01/24.
//  Copyright (c) 2024 bag.xml. All rights reserved.
//

#import "DCContactViewController.h"


@interface DCContactViewController ()

@property DCUser* user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLable;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBox;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@end

@implementation DCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setSelectedUser:(DCUser*)user{
    //pre-init
    self.view = self.view;
    self.navigationItem.title = user.globalName;
    self.nameLabel.text = user.globalName;
    self.handleLable.text = user.username;
    self.snowflake = user.snowflake;
    self.statusIcon.image = [UIImage imageNamed:[self imageNameForStatus:user.status]];
    //image
    self.profileImageView.image = user.profileImage;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hackyMode"] == NO)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.0;
    self.profileImageView.layer.masksToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* userProfileURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://discordapp.com/api/v9/users/%@/profile?with_mutual_guilds=true&with_mutual_friends=true&with_mutual_friends_count=false", user.snowflake]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:userProfileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
        [urlRequest setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
        [urlRequest addValue:DCServerCommunicator.sharedInstance.token forHTTPHeaderField:@"Authorization"];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSHTTPURLResponse *responseCode = nil;
        
        NSError *error = nil;
        NSData *response = [DCTools checkData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error] withError:error];
        if(response){
            
            NSDictionary* parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
            NSLog(@"%@", parsedResponse);
            
            NSDictionary* userProfile = [parsedResponse objectForKey:@"user_profile"];
            NSDictionary* userInfo = [parsedResponse objectForKey:@"user"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pronounLabel.text = [userProfile objectForKey:@"pronouns"];
                self.descriptionBox.text = [userProfile valueForKey:@"bio"];
            });
            
            NSString *bannerHash = [userInfo objectForKey:@"banner"];
            NSString *bannerHexCode = [userInfo objectForKey:@"banner_color"];
            
            if (bannerHash && ![bannerHash isKindOfClass:[NSNull class]]) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://cdn.discordapp.com/banners/%@/%@.png?size=480", [userInfo objectForKey:@"id"], [userInfo objectForKey:@"banner"]]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.profileBanner.image = [UIImage imageWithData:data];
                    
                });
                
            } else {
                //this is actual madness
                if([bannerHexCode isKindOfClass:[NSNull class]]) {
                } else {
                    
                    UIColor *backgroundColor = [UIColorHex colorWithHexString:bannerHexCode];
                    if (backgroundColor)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.bannerView.backgroundColor = backgroundColor;
                            [self.tableView reloadData];
                        });
                }
            }
            
            self.mutualFriends = [parsedResponse objectForKey:@"mutual_friends"];
            self.mutualGuilds = [parsedResponse objectForKey:@"mutual_guilds"];
            NSLog(@"%@", self.mutualFriends);
            

            
            
        }
    });
}

/*table view*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.connected acc count you cunt %@", self.connectedAccounts.count);
    return self.connectedAccounts.count;
}



- (NSString *)imageNameForStatus:(NSString *)status {
    if ([status isEqualToString:@"online"]) {
        return @"online";
    } else if ([status isEqualToString:@"dnd"]) {
        return @"dnd";
    } else if ([status isEqualToString:@"idle"]) {
        return @"absent";
    } else {
        return @"offline";
    }
}

- (IBAction)throwToChat:(id)sender {
    [self performSegueWithIdentifier:@"about to chat" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"about to chat"]) {
        DCChatViewController *chatViewController = [segue destinationViewController];
        if ([chatViewController isKindOfClass:DCChatViewController.class]) {
            DCChannel *privateChannel = [self findPrivateChannelForUser:self.snowflake];
            
            if (privateChannel) {
                DCServerCommunicator.sharedInstance.selectedChannel = privateChannel;
                NSString *formattedChannelName = privateChannel.name;
                [chatViewController.navigationItem setTitle:formattedChannelName];

                if (!chatViewController.messages) {
                    chatViewController.messages = [NSMutableArray array];
                }
                
                [chatViewController getMessages:50 beforeMessage:nil];
                [chatViewController setViewingPresentTime:true];
            } else {
            }
        }
    }
}

- (DCChannel *)findPrivateChannelForUser:(NSString *)userId {
    for (DCGuild *guild in DCServerCommunicator.sharedInstance.guilds) {
        if ([guild.name isEqualToString:@"Direct Messages"]) {
            for (DCChannel *channel in guild.channels) {
                for (NSDictionary *userDict in channel.users) {
                    if ([userDict[@"snowflake"] isEqualToString:userId]) {
                        return channel;
                    }
                }
            }
        }
    }
    return nil;
}

@end
