//
//  SHGenderCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHGenderCell.h"

@implementation SHGenderCell

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

    self.titleLabel.text = @"Gender";
    self.accesoryLabel.text = ([self.user.gender intValue] == 0) ? @"Male" : @"Female";
    
}


@end
