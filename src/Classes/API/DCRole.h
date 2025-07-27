#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface DCRole : NSObject

@property (strong, nonnull) NSString* snowflake;
@property (strong, nonnull) NSString* name;
@property (assign, nonatomic) NSInteger color;
// colors
@property (assign, nonatomic) BOOL hoist;
@property (strong, nullable, nonatomic) NSString* iconID;
@property (strong, nullable, nonatomic) UIImage* icon;
@property (strong, nullable, nonatomic) NSString* unicodeEmoji;
@property (assign, nonatomic) NSInteger position;
@property (strong, nonnull, nonatomic) NSString* permissions;
@property (assign, nonatomic) BOOL managed;
@property (assign, nonatomic) BOOL mentionable;
// tags
@property (assign, nonatomic) NSInteger flags;

- (NSString* _Nonnull)description;

@end