//
//  UserResultCell.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "NINetworkImageView.h"
#import "SHUserCellItem.h"
#import "TTTAttributedLabel.h"

@class User;

@interface UserResultCell : UITableViewCell

@property (nonatomic, strong) NINetworkImageView *userImageView;
@property (nonatomic, strong) TTTAttributedLabel *nameLabel;
@property (nonatomic, strong) UILabel *accesoryLabel;
@property (nonatomic, strong) UIImageView *arrow;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SHUserCellItem *item;
@property (nonatomic, strong) UIView *sepView;

+ (float)rowHeight;

@end
