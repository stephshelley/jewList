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

    CGFloat buttonHeight = 100;
    self.fbConnectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, buttonHeight)];
    _fbConnectButton.backgroundColor = DEFAULT_BLUE_COLOR;
    _fbConnectButton.bottom = self.height;
    [_fbConnectButton setTitle:@"Facebook connect to get started" forState:UIControlStateNormal];
    [_fbConnectButton setTitle:@"Facebook connect to get started" forState:UIControlStateHighlighted];
    _fbConnectButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:18];
    _fbConnectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_fbConnectButton];

}

@end
