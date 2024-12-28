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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLable;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBox;
@end

@implementation DCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //not done yet...
    self.chatButton.hidden = YES;
}

-(void)setSelectedUser:(DCUser*)user{
    //pre-init
    self.view = self.view;
    self.navigationItem.title = user.globalName;
    self.nameLabel.text = user.globalName;
    self.handleLable.text = user.username;
    NSLog(@"status %@", user.status);
    
    //image
    self.profileImageView.image = user.profileImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.0;
    self.profileImageView.layer.masksToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* userProfileURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://discordapp.com/api/v9/users/%@/profile?with_mutual_guilds=false&with_mutual_friends=true&with_mutual_friends_count=false", user.snowflake]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:userProfileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
        [urlRequest setValue:@"no-store" forHTTPHeaderField:@"Cache-Control"];
        [urlRequest addValue:DCServerCommunicator.sharedInstance.token forHTTPHeaderField:@"Authorization"];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSHTTPURLResponse *responseCode = nil;
        
        NSError *error = nil;
        NSData *response = [DCTools checkData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error] withError:error];
        if(response){
            NSDictionary* parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
            NSDictionary* userProfile = [parsedResponse objectForKey:@"user_profile"];
            NSDictionary* userInfo = [parsedResponse objectForKey:@"user"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pronounLabel.text = [userProfile objectForKey:@"pronouns"];
            });
            
            NSString *bannerHash = [userInfo objectForKey:@"banner"];
            
            if (bannerHash && ![bannerHash isKindOfClass:[NSNull class]]) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://cdn.discordapp.com/banners/%@/%@.png?size=480", [userInfo objectForKey:@"id"], [userInfo objectForKey:@"banner"]]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.profileBanner.image = [UIImage imageWithData:data];
                });
                
            } else {
                //this is actual madness
                NSString *bannerHexCode = [userInfo objectForKey:@"banner_color"];
                UIColor *backgroundColor = [UIColorHex colorWithHexString:bannerHexCode];
                if (backgroundColor)
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.bannerView.backgroundColor = backgroundColor;
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.descriptionBox.text = [userProfile valueForKey:@"bio"];
            });
            
            
        }
    });
}
/*
[DCTools processImageDataWithURLString:iconURL andBlock:^(UIImage *imageData) {
    UIImage* icon = imageData;
    
    if (icon != nil) {
        newChannel.icon = icon;
        CGSize itemSize = CGSizeMake(32, 32);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [newChannel.icon  drawInRect:imageRect];
        newChannel.icon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }*/

- (IBAction)throwToChat:(id)sender {
    [self performSegueWithIdentifier:@"guilds to chat" sender:self];

}

@end
