//
//  STOnboarding4View.h
//  JewList
//
//  Created by Oren Zitoun on 12/15/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHOnboardingDelegate.h"

@class User;

@interface STOnboarding4View : UIView <UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic, strong) UIView *yearTopView;

@property (nonatomic, strong) UIPickerView *yearPickerView;
@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *chooseYearLabel;
@property (nonatomic, strong) UIButton *chooseYearButton;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;
- (void)showLoading;
- (void)hideLoading;

@end
