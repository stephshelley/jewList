//
//  SHProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHProfileViewController.h"

@implementation SHProfileViewController

- (id)initWithUser:(User*)user
{
    self = [super init];
    if(self)
    {
        self.user = user;
    }
    
    return self;
    
}

- (void)loadView
{
    [super loadView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 40,24)];
    _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.centerX = floorf(self.view.width/2);
    _nameLabel.top = 20;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _userImageView.centerX = _nameLabel.centerX;
    _userImageView.top = _nameLabel.bottom + 10;
    _userImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_userImageView];
    
}

@end
