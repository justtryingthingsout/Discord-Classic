#import <Foundation/Foundation.h>

@interface DCUserInfo : NSObject

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* globalName;
@property (strong, nonatomic) NSString* pronouns;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* bio;
@property (strong, nonatomic) NSString* banner;
@property (strong, nonatomic) NSString* bannerColor;
@property (strong, nonatomic) NSString* clan;
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSMutableDictionary* connectedAccounts;
@property (strong, nonatomic) NSMutableArray* guildPositions;
@property (strong, nonatomic) NSMutableArray* guildFolders;

@end