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
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 125)];
    _logoImageView.backgroundColor = [UIColor JLGrey];
    [self addSubview:_logoImageView];
    
    self.findLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 88)];
    _findLabel.text = @"Find your jewish\nroomate";
    _findLabel.numberOfLines = 2;
    _findLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _findLabel.backgroundColor = [UIColor JLGrey];
    _findLabel.textColor = [UIColor whiteColor];
    _findLabel.top = _logoImageView.bottom;
    _findLabel.centerX = _logoImageView.centerX;
    _findLabel.textAlignment = NSTextAlignmentCenter;
    _findLabel.layer.borderWidth = 1.0f;
    _findLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_findLabel];
    
    CGFloat buttonHeight = 118.0f;
    self.fbConnectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - buttonHeight, self.frame.size.width, buttonHeight)];
    _fbConnectButton.backgroundColor = [UIColor colorWithRed:0.424 green:0.773 blue:0.98 alpha:1] /*#6cc5fa*/;
    _fbConnectButton.bottom = self.height - 40;
    _fbConnectButton.centerX = _logoImageView.centerX;
    [_fbConnectButton setTitle:@"Next Step" forState:UIControlStateNormal];
    [_fbConnectButton setTitle:@"Next Step" forState:UIControlStateHighlighted];
    _fbConnectButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    [self addSubview:_fbConnectButton];
    
    self.fbConnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _findLabel.width, 40)];
    _fbConnectLabel.text = @"Facebook connect to get started!";
    _fbConnectLabel.textAlignment = NSTextAlignmentCenter;
    _fbConnectLabel.font = [UIFont fontWithName:DEFAULT_FONT size:15];
    _fbConnectLabel.adjustsFontSizeToFitWidth = YES;
    _fbConnectLabel.textColor = [UIColor whiteColor];
    _fbConnectLabel.backgroundColor = [UIColor JLGrey];
    _fbConnectLabel.bottom = _fbConnectButton.top;
    _fbConnectLabel.centerX = _fbConnectButton.centerX;
    [self addSubview:_fbConnectLabel];
    
}

@end
