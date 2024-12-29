//
//  DCConnectedAccountsCell.h
//  Discord Classic
//
//  Created by XML on 29/12/24.
//  Copyright (c) 2024 bag.xml. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCConnectedAccountsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedBadge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
