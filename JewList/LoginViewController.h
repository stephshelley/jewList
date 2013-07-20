//
//  LoginViewController.h
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHLoginOnboardingView.h"
#import "SHOnboarding1View.h"
#import "SHOnboarding2View.h"
#import "SHOnboarding3View.h"

@interface LoginViewController : UIViewController

@property (copy) void (^success)(NSDictionary *dict);
@property (copy) void (^failure)(NSError *error);

@property (nonatomic, strong) id connectToSocialProviderRequest;

@property (nonatomic, strong) SHLoginOnboardingView *loginView;
@property (nonatomic, strong) SHOnboarding1View *onboardingStep1;
@property (nonatomic, strong) SHOnboarding2View *onboardingStep2;
@property (nonatomic, strong) SHOnboarding3View *onboardingStep3;

@end
