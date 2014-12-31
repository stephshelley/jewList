//
//  SHLogoutCellTableViewCell.m
//  JewList
//
//  Created by Oren Zitoun on 3/22/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHLogoutCellTableViewCell.h"
#import "SHApi.h"
#import "UIAlertView+Blocks.h"

@implementation SHLogoutCellTableViewCell

+ (CGFloat)rowHeight
{
    return 60;
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        /*
        self.loginView =
        [[FBLoginView alloc] initWithReadPermissions:
         @[@"user_hometown", @"email", @"user_location",@"user_education_history"]];
        _loginView.bottom = self.height - 20;
        _loginView.centerX = floorf(self.width/2);
        //_loginView.centerX = 160;
        [self.contentView addSubview:_loginView];
        */
        
        self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 280, [SHLogoutCellTableViewCell rowHeight] - 20)];
        [_logoutButton setBackgroundColor:DEFAULT_BLUE_COLOR];
        [_logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:20];
        _logoutButton.titleLabel.textColor = [UIColor whiteColor];
        _logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _logoutButton.centerX = 160;
        _logoutButton.centerY = floorf([SHLogoutCellTableViewCell rowHeight]/2);
        [_logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_logoutButton];

    
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _logoutButton.centerX = CGRectGetMidX(self.bounds);

}

- (void)logoutButtonPressed
{
    [UIAlertView showWithTitle:NSLocalizedString(@"Log Out", nil) message:NSLocalizedString(@"Are you sure you want to log out?", @"") cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:@[NSLocalizedString(@"Yes", nil)] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1)
         {
             [[SHApi sharedInstance] logout];

         }
     }];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
