//
//  STOnboardingAboutMeView.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "SHOnboardingDelegate.h"
#import "UIPlaceHolderTextView.h"

@interface STOnboardingAboutMeView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;
- (void)showLoading;
- (void)hideLoading;

@end
