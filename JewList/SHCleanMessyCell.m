//
//  SHCleanMessyCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHCleanMessyCell.h"

@implementation SHCleanMessyCell

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
    
    self.titleLabel.text = @"Clean/Messy";
    self.textView.text = self.user.cleaningText;
    self.accesoryLabel.text = [self.user.cleaning intValue] == 0 ? @"Clean" : @"Messy";
    
}


@end
