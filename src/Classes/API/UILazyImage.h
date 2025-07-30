#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface UILazyImage: NSObject
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@end
