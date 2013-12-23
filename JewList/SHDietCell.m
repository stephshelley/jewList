//
//  SHDietCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHDietCell.h"

@implementation SHDietCell

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
    
    self.titleLabel.text = @"Diet";
    self.textView.text = self.user.dietText;
    self.accesoryLabel.text = [self.user.diet intValue] == 0 ? @"Kosher" : @"Non Kosher";
    
}

@end
