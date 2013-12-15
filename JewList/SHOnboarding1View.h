//
//  SHOnboarding1View.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "NINetworkImageView.h"
#import "SHTextFieldOnBoarding.h"
#import "UIView+FindAndResignFirstResponder.h"

@class User;
@class SHToggleButton;

@interface SHOnboarding1View : UIView <UITextFieldDelegate>

@property (nonatomic, strong) NINetworkImageView *userImageView;
@property (nonatomic, strong) UILabel *hiLabel;
@property (nonatomic, strong) UILabel *letsGoLabel;

@property (nonatomic, strong) SHTextFieldOnBoarding *nameTextField;
@property (nonatomic, strong) SHTextFieldOnBoarding *homeTownTextField;
@property (nonatomic, strong) SHTextFieldOnBoarding *emailTextField;

@property (nonatomic, strong) UIButton *nextStepButton;

@property (nonatomic, strong) SHToggleButton *maleButton;
@property (nonatomic, strong) SHToggleButton *femaleButton;

@property (nonatomic, strong) User *user;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;

@end
