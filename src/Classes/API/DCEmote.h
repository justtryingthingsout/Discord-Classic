#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#import "DCTools.h"

@interface DCEmote : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) DCSnowflake *snowflake;
@property (assign, nonatomic) BOOL isAnimated;
@property (strong, nonatomic) UIImage *image;

@end
