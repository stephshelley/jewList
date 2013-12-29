//
//  STOnboardingStep5.h
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHOnboardingDelegate.h"
#import "User.h"

@interface STOnboarding5View : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *ageTopView;

@property (nonatomic, strong) UIPickerView *agePickerView;
@property (nonatomic, strong) NSMutableArray *agesArray;
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
