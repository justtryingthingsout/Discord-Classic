//
//  DCContactViewController.m
//  Discord Classic
//
//  Created by bag.xml on 27/01/24.
//  Copyright (c) 2024 Julian Triveri. All rights reserved.
//

#import "DCContactViewController.h"

@interface DCContactViewController ()

@property DCUser* user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLable;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBox;
@end

@implementation DCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //not done yet...
    self.chatButton.hidden = YES;
}

- (void)requestProfileInformation:(DCUser*)user {
    NSURL* userProfileURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://discordapp.com/api/v9/users/%@/profile?with_mutual_guilds=false&with_mutual_friends=true&with_mutual_friends_count=false", user.snowflake]];
    NSLog(@"%@", userProfileURL);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:userProfileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [urlRequest setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
	
	[urlRequest addValue:DCServerCommunicator.sharedInstance.token forHTTPHeaderField:@"Authorization"];
	[urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *responseCode = nil;

    NSError *error = nil;
    NSData *response = [DCTools checkData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error] withError:error];
    if(response){
        NSArray* parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        NSLog(@"%@", parsedResponse);
    }
}


-(void)setSelectedUser:(DCUser*)user{
    self.view = self.view;
    self.navigationItem.title = user.globalName;
    self.nameLabel.text = user.globalName;
    self.handleLable.text = user.username;
    self.profileImageView.image = user.profileImage;
    self.profileBanner.image = user.profileBanner;
    self.user = user;
    self.descriptionBox.text = user.description;
}

- (IBAction)throwToChat:(id)sender {
    [self performSegueWithIdentifier:@"guilds to chat" sender:self];

}

@end
