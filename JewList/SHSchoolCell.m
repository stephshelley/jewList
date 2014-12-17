//
//  SHSchoolCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/16/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHSchoolCell.h"
#import "SHApi.h"

@implementation SHSchoolCell

+ (CGFloat)rowHeight
{
    return 50;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel.width = 90;
        self.accesoryLabel.width = 200;
        self.accesoryLabel.right = 310;

    }
    
    return self;
    
}

- (void)setUser:(User *)user
{
    [super setUser:user];
    
    self.titleLabel.text = @"School";
    self.accesoryLabel.text = user.college.collegeName;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
