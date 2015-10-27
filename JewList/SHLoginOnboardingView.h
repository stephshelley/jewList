//
//  SHLoginOnboardingView.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SHLoginOnboardingView : UIView

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *findLabel;

@property (nonatomic, strong) UILabel *fbConnectLabel;
@property (nonatomic, strong) UIButton *fbConnectButton;
@property (nonatomic, strong) FBSDKLoginButton *loginButton;

@end
