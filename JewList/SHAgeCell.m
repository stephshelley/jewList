//
//  SHAgeCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHAgeCell.h"

@implementation SHAgeCell

+ (CGFloat)rowHeight
{
    return 50;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

- (void)setUser:(User *)user
{
    [super setUser:user];
    
    self.titleLabel.text = @"Age";
    self.accesoryLabel.text = [NSString stringWithFormat:@"%d",[self.user.age integerValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
