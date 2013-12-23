//
//  SHShabatCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHShabatCell.h"

@implementation SHShabatCell

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
    
    self.titleLabel.text = @"How jew are you?";
    self.textView.text = self.user.religiousText;
    
    switch ([self.user.religious intValue]) {
        case 0:
        {
            self.accesoryLabel.text = @"Uber Jew";
            break;
        }
        case 1:
        {
            self.accesoryLabel.text = @"Mild Jew";
            break;
        }
        case 2:
        {
            self.accesoryLabel.text = @"Meh Jew";
            break;
        }
        default:
            break;
    }
    
    
}

@end
