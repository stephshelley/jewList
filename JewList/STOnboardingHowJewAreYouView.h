//
//  STOnboardingHowJewAreYouView.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHToggleButton.h"
#import "User.h"
#import "SHOnboardingDelegate.h"
#import "UIPlaceHolderTextView.h"

@interface STOnboardingHowJewAreYouView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SHToggleButton *uberJew;
@property (nonatomic, strong) SHToggleButton *mildJew;
@property (nonatomic, strong) SHToggleButton *mehJew;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;

@end
