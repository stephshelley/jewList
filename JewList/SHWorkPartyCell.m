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
    
    self.titleLabel.text = @"Do you spend more time working or playing?";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.height = 40;
    self.textView.text = self.user.personalityText;
    self.textView.top = self.titleLabel.bottom + 7;
    self.textView.height = [SHTextAndOptionCell rowHeight] - self.titleLabel.bottom - 13;
    self.accesoryLabel.text = [self.user.personality intValue] == 0 ? @"Work" : @"Party";
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.height = [SHTextAndOptionCell rowHeight] - self.titleLabel.bottom - 13;

}

@end
