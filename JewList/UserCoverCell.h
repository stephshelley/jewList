//
//  UserCoverCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserCoverCell : UITableViewCell

@property (nonatomic) User *user;

+ (CGFloat)cellHeight;

@end
