//
//  STOnboardingWorkPlayView.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "SHTextEditViewController.h"
#import "SHToggleButton.h"
#import "UIPlaceHolderTextView.h"
#import "SHOnboardingDelegate.h"

@interface STOnboardingWorkPlayView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SHToggleButton *workButton;
@property (nonatomic, strong) SHToggleButton *playButton;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;
@property (nonatomic, strong) UIButton *nextStepButton;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;

@end
