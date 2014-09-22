//
//  SHLocationCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHLocationCell.h"

@implementation SHLocationCell

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
    
    self.titleLabel.text = @"Where you looking to live?";
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.accesoryLabel.text = ([self.user.campus intValue] == 0) ? @"On campus" : @"Off campus";
    
}

@end
