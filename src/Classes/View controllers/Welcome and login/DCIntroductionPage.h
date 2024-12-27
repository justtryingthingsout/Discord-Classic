//
//  DCIntroductionPage.h
//  Discord Classic
//
//  Created by bag.xml on 28/01/24.
//  Copyright (c) 2024 bag.xml. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCIntroductionPage : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property bool authenticated;

@end
