//
//  SHTextItemCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextItemCell.h"
#import "JLColors.h"

@implementation SHTextItemCell

+ (CGFloat)rowHeight
{
    return 100;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 16)];
        _titleLabel.textColor = DEFAULT_BLUE_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.top = 5;
        _titleLabel.left = 10;
        _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:_titleLabel.height-3];
        [self.contentView addSubview:_titleLabel];
        

        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom + 7, 300, [SHTextItemCell rowHeight] - _titleLabel.bottom - 13)];
        _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.userInteractionEnabled = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_BLUE_COLOR;
        _textView.font = [UIFont fontWithName:DEFAULT_FONT size:17];
        _textView.centerX = 160;
        _textView.clipsToBounds = YES;
        [self.contentView addSubview:_textView];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        sep.backgroundColor = UIColorFromRGB(0xebebec);
        sep.bottom = [SHTextItemCell rowHeight];
        [self.contentView addSubview:sep];
        
    }
    
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end