//
//  ProfileDetailCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/20/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDetailCellItem.h"

@interface ProfileDetailCell : UITableViewCell

@property (nonatomic) ProfileDetailCellItem *item;

+ (CGFloat)cellHeightForItem:(ProfileDetailCellItem *)item;

@end
