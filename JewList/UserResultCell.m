//
//  UserResultCell.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "UserResultCell.h"
#import "User.h"

@implementation UserResultCell

+ (float)rowHeight
{
    return IsIpad ? 90 : 70;
}

/* Init */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGFloat cellWidth = IsIpad ? 700 : 320;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _userImageView.left = 10;
        _userImageView.top = 10;
        _userImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_userImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280,20)];
        _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.left = _userImageView.right + 5;
        _nameLabel.width = cellWidth - 10 - (_userImageView.right + 10);
        _nameLabel.top = _userImageView.top + 2;
        _nameLabel.adjustsFontSizeToFitWidth = NO;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        self.accesoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 5, _nameLabel.width, 16)];
        _accesoryLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_accesoryLabel.height - 2)];
        _accesoryLabel.textColor = [UIColor whiteColor];
        _accesoryLabel.adjustsFontSizeToFitWidth = NO;
        _accesoryLabel.backgroundColor = [UIColor clearColor];
        _accesoryLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_accesoryLabel];
        
    }
    
    return self;
    
}


- (void)setUser:(User *)user
{
    _user = user;
    [_userImageView setPathToNetworkImage:_user.fbImageUrl forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
    _accesoryLabel.text = [NSString stringWithFormat:@"%@, %@, %@", [self getGenderSign], _user.age, _user.fbHometownName];
    
}

- (NSString*)getGenderSign
{
    NSString *gender = nil;
    
    if([_user.gendre isEqualToString:@"male"])
    {
        gender = @"M";
    }else if([_user.gendre isEqualToString:@"female"])
    {
        gender = @"F";
    }else{
        gender = @"";
    }
    
    return gender;
}

@end
