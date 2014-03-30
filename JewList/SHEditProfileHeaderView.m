//
//  SHEditProfileHeaderView.m
//  JewList
//
//  Created by Oren Zitoun on 3/30/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHEditProfileHeaderView.h"

@implementation SHEditProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280,18)];
        _titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_titleLabel.height-4)];
        _titleLabel.textColor = DEFAULT_LIGHT_GRAY_COLOR;
        _titleLabel.centerY = floorf(self.height/2) + 1;
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    
    }
    
    return self;
    
}


@end
