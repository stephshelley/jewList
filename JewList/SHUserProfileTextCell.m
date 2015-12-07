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
        self.backgroundColor = [UIColor clearColor];
        
        self.whiteBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _whiteBG.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whiteBG];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 16)];
        _titleLabel.textColor = DEFAULT_LIGHT_GRAY_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.top = 2;
        _titleLabel.left = 10;
        _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_titleLabel.height-3];
        [self.contentView addSubview:_titleLabel];
        
        
        self.titleTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        _titleTypeLabel.textColor = DEFAULT_BLUE_COLOR;
        _titleTypeLabel.textAlignment = NSTextAlignmentRight;
        _titleTypeLabel.top = 2;
        _titleTypeLabel.right = 310;
        _titleTypeLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_titleTypeLabel.height-3];
        [self.contentView addSubview:_titleTypeLabel];
        
        /*
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
        sep.backgroundColor = UIColorFromRGB(0xcccccc);
        sep.top = _titleLabel.bottom + 3;
        sep.centerX = 160;
        [self.contentView addSubview:sep];
         */
        
        CGFloat textviewTop = _whiteBG.bottom + 10;

        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, textviewTop, 300, 30)];
        _textView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.userInteractionEnabled = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_DARK_GRAY_COLOR;
        _textView.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:kCellTextFontSize];
        _textView.left = 5;
        _textView.clipsToBounds = YES;
        [self.contentView addSubview:_textView];
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    _whiteBG.width = width;
    _titleTypeLabel.right = width - 10;
    _textView.width = width - 20;
    _textView.left = 5;

    
}

- (void)setItem:(SHTextCellItem *)item
{
    _item = item;
    _titleLabel.text = _item.title;
    _titleTypeLabel.text = _item.type;
    _textView.text = _item.text;
    _textView.height = [SHUIHelpers getTextHeight:_textView.text font:[UIFont fontWithName:DEFAULT_FONT size:kCellTextFontSize] withCapHeight:1000 width:_textView.width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
