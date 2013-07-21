//
//  SHCollegeCell.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHCollegeCell.h"
#import "JLColors.h"

@implementation SHCollegeCell

+ (float)rowHeight
{
    return IsIpad ? 80 : 28;
}

/* Init */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //CGFloat cellWidth = IsIpad ? 700 : 320;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280,18)];
        _nameLabel.alpha = 0.8;
        _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.centerY = floorf([SHCollegeCell rowHeight]/2);
        _nameLabel.adjustsFontSizeToFitWidth = NO;
        _nameLabel.backgroundColor = [UIColor JLDarkBlue];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
    }
    
    return self;
    
}

@end
