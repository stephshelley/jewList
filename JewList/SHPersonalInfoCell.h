//
//  SHPersonalInfoCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SHPersonalInfoCell : UITableViewCell

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UILabel *accesoryLabel;
@property (nonatomic, strong) UILabel *titleLabel;

+ (CGFloat)rowHeight;

@end
