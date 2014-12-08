//
//  STOnboardingKosherView.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "SHToggleButton.h"
#import "SHOnboardingDelegate.h"
#import "UIPlaceHolderTextView.h"

@interface STOnboardingKosherView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SHToggleButton *kosherButton;
@property (nonatomic, strong) SHToggleButton *nonKosherButton;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;


@end
