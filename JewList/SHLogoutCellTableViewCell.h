//
//  SHLogoutCellTableViewCell.h
//  JewList
//
//  Created by Oren Zitoun on 3/22/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLogoutCellTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIButton *logoutButton;

+ (CGFloat)rowHeight;

@end
