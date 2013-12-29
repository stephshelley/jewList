//
//  SHTextCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHUserProfileTextCell.h"
#import "SHUIHelpers.h"

@implementation SHUserProfileTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 16)];
        _titleLabel.textColor = DEFAULT_BLUE_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.top = 8;
        _titleLabel.left = 20;
        _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:_titleLabel.height-3];
        [self.contentView addSubview:_titleLabel];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
        sep.backgroundColor = UIColorFromRGB(0xebebec);
        sep.top = _titleLabel.bottom + 3;
        sep.centerX = 160;
        [self.contentView addSubview:sep];
        
        CGFloat textviewTop = sep.bottom + 10;

        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, textviewTop, 280, 30)];
        _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.userInteractionEnabled = NO;
        _textView.editable = NO;
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont fontWithName:DEFAULT_FONT size:kCellTextFontSize];
        _textView.centerX = 160;
        _textView.clipsToBounds = YES;
        [self.contentView addSubview:_textView];
        
    }
    
    return self;
    
}

- (void)setItem:(SHTextCellItem *)item
{
    _item = item;
    _titleLabel.text = _item.title;
    _textView.text = _item.text;
    _textView.height = [SHUIHelpers getTextHeight:_textView.text font:[UIFont fontWithName:DEFAULT_FONT size:kCellTextFontSize] withCapHeight:1000 width:_textView.width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
