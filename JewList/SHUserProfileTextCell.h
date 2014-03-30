//
//  SHTextCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextCellItem.h"

@interface SHUserProfileTextCell : UITableViewCell

@property (nonatomic, strong) SHTextCellItem *item;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleTypeLabel;
@property (nonatomic, strong) UITextView *textView;

@end
