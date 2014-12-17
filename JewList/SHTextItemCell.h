//
//  SHTextItemCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@interface SHTextItemCell : UITableViewCell

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *sepView;

+ (CGFloat)rowHeight;


@end
