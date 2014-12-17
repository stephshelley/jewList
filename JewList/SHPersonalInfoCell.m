//
//  SHPersonalInfoCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHPersonalInfoCell.h"

@implementation SHPersonalInfoCell

+ (CGFloat)rowHeight
{
    return 50;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 19)];
        _titleLabel.textColor = DEFAULT_DARK_GRAY_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.centerY = floorf([SHPersonalInfoCell rowHeight]/2);
        _titleLabel.left = 10;
        _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_titleLabel.height-3];
        [self.contentView addSubview:_titleLabel];
        
        self.accesoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 18)];
        _accesoryLabel.centerY = _titleLabel.centerY;
        _accesoryLabel.right = 310;
        _accesoryLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_accesoryLabel.height-2];
        _accesoryLabel.textColor = DEFAULT_BLUE_COLOR;
        _accesoryLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_accesoryLabel];
        
        self.sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        _sepView.backgroundColor = UIColorFromRGB(0xcccccc);
        _sepView.bottom = [SHPersonalInfoCell rowHeight];
        [self.contentView addSubview:_sepView];
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellWidth = self.bounds.size.width;
    _sepView.width = cellWidth;
    _accesoryLabel.right = cellWidth - 10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
