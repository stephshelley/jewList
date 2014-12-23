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
    
    self.titleLabel.text = @"Are You clean or messy?";
    self.textView.text = self.user.cleaningText;
    
    switch ([self.user.cleaning intValue]) {
        case 0:
        {
            self.accesoryLabel.text = @"Messy";
            break;
        }
        case 1:
        {
            self.accesoryLabel.text = @"Organized";
            break;
        }
        case 2:
        {
            self.accesoryLabel.text = @"Clean Freak";
            break;
        }
            
        default:
            break;
    }
    
}


@end
