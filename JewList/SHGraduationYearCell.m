//
//  SHGraduationYearCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHGraduationYearCell.h"

@implementation SHGraduationYearCell

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

    self.titleLabel.text = @"Graduation Year";
    self.accesoryLabel.text = [self.user.gradYear stringValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
