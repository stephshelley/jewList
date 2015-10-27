//
//  SHLoginOnboardingView.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHLoginOnboardingView.h"
#import "JLColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHLoginOnboardingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        
    }
    
    return self;
}

- (void)loadUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"joomieLogo"]];
    _logoImageView.backgroundColor = [UIColor clearColor];
    _logoImageView.centerX = floor(self.width/2);
    _logoImageView.top = 50 + (IS_IOS7 ? 20 : 0);
    [self addSubview:_logoImageView];

    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.readPermissions =
    @[@"user_hometown", @"email", @"user_location",@"user_education_history"];
    self.loginButton.bottom = self.height - 20;
    self.loginButton.centerX = floorf(self.width/2);
    [self addSubview:self.loginButton];
    

}

@end
