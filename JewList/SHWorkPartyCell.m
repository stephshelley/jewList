//
//  SHWorkPartyCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHWorkPartyCell.h"

@implementation SHWorkPartyCell

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
    
    self.titleLabel.text = @"Work/Party";
    self.textView.text = self.user.personalityText;
    self.accesoryLabel.text = [self.user.personality intValue] == 0 ? @"Work" : @"Party";
    
}

@end
