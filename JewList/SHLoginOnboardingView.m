//
//  SHLoginOnboardingView.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHLoginOnboardingView.h"

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
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
    _logoImageView.top = 40;
    _logoImageView.centerX = floor(self.width/2);
    _logoImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_logoImageView];
    
    self.findLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    _findLabel.text = @"Find your jewish\nroomate";
    _findLabel.numberOfLines = 2;
    _findLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _findLabel.backgroundColor = [UIColor darkGrayColor];
    _findLabel.textColor = [UIColor whiteColor];
    _findLabel.top = _logoImageView.bottom;
    _findLabel.centerX = _logoImageView.centerX;
    _findLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_findLabel];
    
    self.fbConnectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _findLabel.width, 80)];
    _fbConnectButton.backgroundColor = [UIColor blueColor];
    _fbConnectButton.bottom = self.height - 40;
    _fbConnectButton.centerX = _logoImageView.centerX;
    [_fbConnectButton setTitle:@"Next Step" forState:UIControlStateNormal];
    [_fbConnectButton setTitle:@"Next Step" forState:UIControlStateHighlighted];
    _fbConnectButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    [self addSubview:_fbConnectButton];
    
    self.fbConnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _findLabel.width, 40)];
    _fbConnectLabel.text = @"Facebook connect to get started bubble";
    _fbConnectLabel.textAlignment = NSTextAlignmentCenter;
    _fbConnectLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _fbConnectLabel.adjustsFontSizeToFitWidth = YES;
    _fbConnectLabel.textColor = [UIColor whiteColor];
    _fbConnectLabel.backgroundColor = [UIColor darkGrayColor];
    _fbConnectLabel.bottom = _fbConnectButton.top;
    _fbConnectLabel.centerX = _fbConnectButton.centerX;
    [self addSubview:_fbConnectLabel];
    
}

@end
